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
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
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
                    
                    
                    Text("I'm an independant software developer in Los Angeles, California. I first made this app back in 2015 when I was living next to Dodger Stadium and often had to get creative with my parking on game nights. Since then I've continued to refine the app and add new features to make it even better. If you enjoy Carpark, please consider throwing a tip my way! It'll help fund future development, in addition to earning you my immense grattitude 😊")
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
                
                ForEach(products) { product in
                    HStack {
                        ProductView(product)
                            .productViewStyle(.compact)
                        Spacer()
                    }
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
