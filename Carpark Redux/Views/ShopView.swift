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
    @State private var lastPurchase: StoreKit.Transaction? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                VStack {
                    HStack {
                        Image("mack")
                            .resizable().scaledToFill()
                            .frame(maxWidth: 60, maxHeight: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Text("Hi, I'm Mack!")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    
                    Text(skClient.salesPitch)
                        .italic()
                }
                .padding()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background {
                    Rectangle().foregroundStyle(Color.accentColor.gradient)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 2, x: 0, y: 1)
                
                
                if let purchase = lastPurchase, let product = products.first(where: {$0.id == purchase.productID}) {
                    VStack {
                        Image(systemName: "fireworks")
                            .resizable().scaledToFit()
                            .padding()
                            .foregroundStyle(.yellow, .white)
                            .background {
                                Circle()
                                    .foregroundStyle(Color(red: 25/255, green: 25/255, blue: 112/255))
                            }
                            .frame(maxWidth: 100)
                            
                        
                        Text("Thank you so much!")
                            .fontWeight(.black)
                            .font(.title2)
                            .foregroundStyle(Color.accentColor)
                        Text("You contributed a \(product.displayName.lowercased()) on \(Utility.simpleDate(from: purchase.purchaseDate)). I cherish you 🙏")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: 320)
                    .padding(.vertical)
                }
                
                ForEach(products) { product in
                    
                    ProductView(product, prefersPromotionalIcon: false) {
                        Image(product.imageName ?? "")
                            .resizable().scaledToFill()
                            .clipShape(Circle())
                    }
                    .productViewStyle(.compact)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.primary).colorInvert()
                            .shadow(radius: 2, x: 0, y: 1)
                    }
                }
                
                Spacer()
                
                Button("Restore Purchase") {
                    Task {
                        do {
                            try await AppStore.sync()
                        } catch {
                            purchaseError = .system(error)
                        }
                    }
                }
                .tint(.secondary)
                .frame(maxWidth: .infinity)
            }
            .padding()
            
            
        }
        .navigationTitle("Tip Jar")
        .task {
            products = await skClient.products.sorted(by: {$0.price < $1.price})
            checkForPastPurchases()
        }
        .storeButton(.visible, for: .restorePurchases)
        .onInAppPurchaseCompletion { product, result in
            Task {
                do {
                    try await skClient.processPurchaseResult(result)
                    checkForPastPurchases()
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
    
    func checkForPastPurchases() {
        Task {
            do {
                var purchases: [StoreKit.Transaction] = []
                for productID in skClient.productIDs {
                    if let last = try await skClient.lastPurchase(productID) {
                        purchases.append(last)
                    }
                }
                
                lastPurchase = purchases.sorted(by: {$0.purchaseDate < $1.purchaseDate}).last
            } catch {
                if let customError = error as? IAPError {
                    purchaseError = customError
                } else {
                    purchaseError = .system(error)
                }
            }
        }
    }
}

#Preview {
    ShopView()
}
