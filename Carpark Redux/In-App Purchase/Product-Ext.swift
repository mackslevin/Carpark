//
//  Product-Ext.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 10/31/24.
//

import Foundation
import StoreKit

extension Product {
    public var imageName: String? {
        self.id.components(separatedBy: ".").last
    }
}
