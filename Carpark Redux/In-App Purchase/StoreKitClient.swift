//
//  StoreKitClient.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 10/30/24.
//

import Foundation
import StoreKit

actor StoreKitClient {
    var products: [Product] = []
    var iapError: IAPError? = nil

    let salesPitch: String = "I'm an independant software developer in Los Angeles, California. I first made this app back in 2015 when I was living next to Dodger Stadium and often had to get creative with my parking on game nights. Since then I've continued to refine the app and add new features to make it even better. If you enjoy Carpark, please consider throwing a tip my way! It'll help fund future development, in addition to earning you my immense grattitude 😊"
    
    let productIDs: Set<Product.ID> = [
        "com.johnslevin.Carpark.iap.goodTip",
        "com.johnslevin.Carpark.iap.greatTip",
        "com.johnslevin.Carpark.iap.phenomenalTip",
        "com.johnslevin.Carpark.iap.unfathomableTip"
    ]
    
    init() {
        Task {
            await self.requestProducts()
        }
        
        Task {
            await self.listenForTransactions()
        }
    }
    
    func isPurchased(_ productID: Product.ID) async throws -> Bool {
        guard let result = await Transaction.latest(for: productID) else {
            print("^^ no past transactions")
            return false
        }
        let transaction = try checkVerified(result)
        return transaction.revocationDate == nil
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    // TODO: Mark in SwiftData that a purchase has been made? Or just use isPurchased?
                    await transaction.finish()
                } catch {
                    print("^^ Transaction listener: \(error)")
                }
            }
        }
    }
    
//    func purchase(_ product: Product) async throws -> Transaction? {
//        let result = try await product.purchase()
//        
//        switch result {
//            case .success(let verificationResult):
//                let transaction = try checkVerified(verificationResult)
//                await transaction.finish()
//                
//                // TODO: Mark in SwiftData that a purchase has been made? Or just use isPurchased?
//                
//                return transaction
//            case .userCancelled, .pending:
//                return nil
//            default:
//                return nil
//        }
//    }
    
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
                            
                            // TODO: Mark in SwiftData that a purchase has been made? Or just use isPurchased?
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
                print("^^ boo")
                throw .system(error)
            }
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
