//
//  Utility.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 1/2/24.
//

import Foundation

struct Utility {
    
    // User defaults key for first run of the SwiftUI (post-UIKit) version of the app. It's a bool we set to true after and old user data has been migrated.
    static let dataMigratedFromUIKit = "dataHasBeenMigratedFromUIKitVersion"
    
    static let exampleSpot = ParkingSpot(latitude: 34.10325647753972, longitude: -118.31919351426978)
}
