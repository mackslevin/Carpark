//
//  StoreKitClient.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 10/30/24.
//

import SwiftUI
import StoreKit
import Observation


private struct StoreKitClientKey: EnvironmentKey {
    static let defaultValue: StoreKitClient = StoreKitClient()
}

extension EnvironmentValues {
    var storeKitClient: StoreKitClient {
        get { self[StoreKitClientKey.self] }
        set { self[StoreKitClientKey.self] = newValue }
    }
}

actor StoreKitClient {
    var products: [Product] = []
    var iapError: IAPError? = nil

    let salesPitch: String = "I'm an independant software developer in Los Angeles, California. I first made this app back in 2015 when I was living next to Dodger Stadium and often had to get creative with my parking on game nights. Since then I've continued to refine the app and add new features to make it even better. If you enjoy Carpark, please consider throwing a tip my way! It'll help fund future development, in addition to earning you my immense grattitude 😊"
    
    let productNames: [String:String] = [
        "com.johnslevin.Carpark.iap.goodTip": "Good Tip",
        "com.johnslevin.Carpark.iap.greatTip": "Great Tip",
        "com.johnslevin.Carpark.iap.phenomenalTip": "Phenomenal Tip",
        "com.johnslevin.Carpark.iap.unfathomableTip": "Unfathomable Tip"
    ]
    
    var productIDs: Set<Product.ID> {
        return Set(productNames.keys)
    }
    
    init() {
        Task {
            await self.requestProducts()
        }
        
        Task {
            await self.listenForTransactions()
        }
    }
    
    func lastPurchase(_ productID: Product.ID) async throws -> StoreKit.Transaction? {
        guard let result = await Transaction.latest(for: productID) else {
            return nil
        }
        
        let transaction = try checkVerified(result)
        if transaction.revocationDate != nil {
            return nil
        }
        
        return transaction
    }
    
//    func isPurchased(_ productID: Product.ID) async throws -> Bool {
//        guard let result = await Transaction.latest(for: productID) else {
//            print("^^ no past transactions")
//            return false
//        }
//        let transaction = try checkVerified(result)
//        
//        return transaction.revocationDate == nil
//    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    await transaction.finish()
                    
                    // TODO: Handle refunded
                    
                    await self.savePurchaseData(transaction)
                } catch {
                    print("^^ Transaction listener: \(error)")
                }
            }
        }
    }
    
    func processPurchaseResult(_ result: Result<Product.PurchaseResult, any Error>) async throws(IAPError)  {
        do {
            switch result {
                case .failure(let error):
                    throw error
                case .success(let purchaseResult):
                    
                    switch purchaseResult {
                        case .success(let verificationResult):
                            let transaction = try checkVerified(verificationResult)
                            await transaction.finish()
                            await savePurchaseData(transaction)
                        case .pending:
                            throw IAPError.purchasePending
                        default:
                            throw IAPError.unknownPurchaseState
                    }
            }
        } catch {
            if let customError = error as? IAPError {
                throw customError
            } else {
                throw .system(error)
            }
        }
    }
    
    @MainActor
    private func savePurchaseData(_ transaction: StoreKit.Transaction) {
        let iap = InAppPurchase(transaction: transaction)
        DataCenter.shared.container.mainContext.insert(iap)
        do {
            try DataCenter.shared.container.mainContext.save()
        } catch {
            print("^^ Error saving purchase data: \(error)")
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
            case .unverified(_, _):
                throw IAPError.unverified
            case .verified(let signedType):
                return signedType
        }
    }

    func requestProducts() async {
        do {
            let storeProducts = try await Product.products(for: productIDs)
            products = storeProducts
        } catch {
            self.iapError = .system(error)
        }
    }
}
