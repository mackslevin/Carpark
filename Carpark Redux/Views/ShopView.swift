//
//  ShopView.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 10/31/24.
//

import SwiftUI
import StoreKit

struct ShopView: View {
    let skClient = StoreKitClient()
    
    @State private var products: [Product] = []
    @State private var purchaseError: IAPError? = nil
    
    var body: some View {
        StoreView(products: products)
            .task {
                products = await skClient.products
                
                for product in products {
                    let isPurchased = try! await skClient.isPurchased(product.id)
                    print("^^ Has purchased \(product.displayName)? \(isPurchased)")
                }
            }
            .storeButton(.visible, for: .restorePurchases)
            .onInAppPurchaseCompletion { product, result in
                Task {
                    do {
                        try await skClient.processPurchaseResult(result)
                    } catch {
                        purchaseError = error as? IAPError
                    }
                }
            }
            .alert("Purchase Failed", isPresented: .init(
                get: { purchaseError != nil },
                set: { if !$0 { purchaseError = nil } }
            )) {
                Button("OK", role: .cancel) {
                    purchaseError = nil
                }
            } message: {
                Text(purchaseError?.localizedDescription ?? "")
            }
    }
}

#Preview {
    ShopView()
}
