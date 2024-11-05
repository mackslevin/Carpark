//
//  InAppPurchase.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 11/5/24.
//

import Foundation
import SwiftData
import StoreKit

@Model
class InAppPurchase {
    private(set) var transactionID: UInt64 = 0
    private(set) var purchaseDate: Date = Date.now
    private(set) var price: Decimal?
    private(set) var currency: Locale.Currency?
    private(set) var productID: String = ""
    
    var jsonRepresentation: Data?
    
    var productName: String? {
        let skClient = StoreKitClient()
        return skClient.productNames[productID]
    }
    
    init(transaction: Transaction) {
        self.transactionID = transaction.id
        self.purchaseDate = transaction.purchaseDate
        self.jsonRepresentation = transaction.jsonRepresentation
        self.price = transaction.price
        self.currency = transaction.currency
        self.productID = transaction.productID
    }
}
