//
//  Item.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 1/2/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
