//
//  ShopView.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 10/31/24.
//

import SwiftUI
import StoreKit
import SwiftData

struct ShopView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage(StorageKeys.customAccentColor.rawValue) var customAccentColor: CustomAccentColor = .indigo
    @Query var pastPurchases: [InAppPurchase]
    
    let skClient = StoreKitClient()
    
    @State private var products: [Product] = []
    @State private var purchaseError: IAPError? = nil
    @State private var lastPurchase: StoreKit.Transaction? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // MARK: Sales pitch
                HStack {
                    Spacer()
                    Image("mack")
                        .resizable().scaledToFill()
                        .frame(maxWidth: 60, maxHeight: 60)
                        .clipShape(Circle())
                    
                    Text("Hi, I'm Mack!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.tint)
                    Spacer()
                }
                
                Text(skClient.salesPitch)
                    .padding()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .background {
                        Rectangle().foregroundStyle(Color.accentColor.gradient)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // MARK: "Thank you" view
                if let purchase = lastPurchase, let product = products.first(where: {$0.id == purchase.productID}) {
                    VStack {
                        Image(systemName: "fireworks")
                            .resizable().scaledToFit()
                            .padding()
                            .foregroundStyle(customAccentColor.rawValue == "yellow" ? .orange : .yellow, .white)
                            .background {
                                Circle()
                                    .foregroundStyle(.tint)
                            }
                            .frame(maxWidth: 100)
                        
                        Text("Thank you so much!")
                            .fontWeight(.black)
                            .font(.title2)
                            .foregroundStyle(Color.accentColor)
                        Text("You contributed \(product.displayName == "Unfathomable Tip" ? "an" : "a") \(product.displayName.lowercased()) on \(Utility.simpleDate(from: purchase.purchaseDate)). I cherish you 🙏")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: 320)
                    .padding(.vertical)
                }
                
                if let iap = pastPurchases.sorted(by: {$0.purchaseDate < $1.purchaseDate}).last {
                    VStack {
                        Image(systemName: "fireworks")
                            .resizable().scaledToFit()
                            .padding()
                            .foregroundStyle(customAccentColor.rawValue == "yellow" ? .orange : .yellow, .white)
                            .background {
                                Circle()
                                    .foregroundStyle(.tint)
                            }
                            .frame(maxWidth: 100)
                        
                        Text("Thank you so much!")
                            .fontWeight(.black)
                            .font(.title2)
                            .foregroundStyle(Color.accentColor)
                        
                        if let name = iap.productName {
                            Text("You contributed \(name == "Unfathomable Tip" ? "an" : "a") \(name.lowercased()) on \(Utility.simpleDate(from: iap.purchaseDate)). I cherish you 🙏")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("You contributed on \(Utility.simpleDate(from: iap.purchaseDate)). I cherish you 🙏")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: 320)
                    .padding(.vertical)
                }
                
                // MARK: Products
                ForEach(products) { product in
                    ProductView(product, prefersPromotionalIcon: false)
                        .productViewStyle(.compact)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(Color(UIColor.secondarySystemGroupedBackground))
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
        .background {
            Rectangle()
                .foregroundStyle(Color(UIColor.systemGroupedBackground)) // Match the background color of a List
                .ignoresSafeArea()
        }
        .navigationTitle("Tip Jar")
        .task {
            products = await skClient.products.sorted(by: {$0.price < $1.price})
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
        .alert("The purchase was not completed", isPresented: .init(
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
    
//    func checkForPastPurchases() {
//        Task {
//            do {
//                var purchases: [StoreKit.Transaction] = []
//                for productID in skClient.productIDs {
//                    if let last = try await skClient.lastPurchase(productID) {
//                        purchases.append(last)
//                    }
//                }
//                
//                lastPurchase = purchases.sorted(by: {$0.purchaseDate < $1.purchaseDate}).last
//            } catch {
//                if let customError = error as? IAPError {
//                    purchaseError = customError
//                } else {
//                    purchaseError = .system(error)
//                }
//            }
//        }
//    }
}

#Preview {
    ShopView()
        .fontDesign(.rounded)
}
