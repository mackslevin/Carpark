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
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
            case .success(let verificationResult):
                let transaction = try checkVerified(verificationResult)
                await transaction.finish()
                
                // TODO: Mark in SwiftData that a purchase has been made? Or just use isPurchased?
                
                return transaction
            case .userCancelled, .pending:
                return nil
           default:
                return nil
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
            let storeProducts = try await Product.products(for: getProductIDs())
            products = storeProducts
        } catch {
            self.iapError = .system(error)
        }
    }
    
    private func getProductIDs() -> Set<Product.ID> {
        guard let url = Bundle.main.url(forResource: "ProductIDs", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil)
                as? [String: Any],
              let productIDs = plist["ProductIDs"] as? [String] else {
            return []
        }
        print("^^ \(productIDs)")
        
        return Set(productIDs)
    }
}
