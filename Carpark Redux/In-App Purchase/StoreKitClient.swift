//
//  StoreKitClient.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 10/30/24.
//

import Foundation
import StoreKit

actor StoreKitClient {
    
    @MainActor
    func getProductIDs() -> Set<Product.ID> {
        guard let url = Bundle.main.url(forResource: "ProductIDs", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil)
                as? [String: Any],
              let productIDs = plist["ProductIDs"] as? [String] else {
            return []
        }
        return Set(productIDs)
    }
}
