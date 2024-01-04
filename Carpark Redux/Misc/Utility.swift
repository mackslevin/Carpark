//
//  Utility.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 1/2/24.
//

import SwiftUI
import MapKit

struct Utility {
    
    // User defaults key for first run of the SwiftUI (post-UIKit) version of the app. It's a bool we set to true after and old user data has been migrated.
    static let dataMigratedFromUIKit = "dataHasBeenMigratedFromUIKitVersion"
    
    static let exampleSpot = ParkingSpot(latitude: 34.10325647753972, longitude: -118.31919351426978)
    
    static func mapStyle(forMapPreference mapPreference: MapPreference) -> MapStyle {
        switch mapPreference {
            case .hybrid:
                MapStyle.hybrid
            case .imagery:
                MapStyle.imagery
            case .standard:
                MapStyle.standard
        }
    }
    
    static func color(forCustomAccentColor custom: CustomAccentColor) -> Color {
        switch custom {
            case .indigo:
                Color.indigo
            case .yellow:
                Color.yellow
            case .pink:
                Color.pink
            case .blue:
                Color.blue
            case .brown:
                Color.brown
            case .cyan:
                Color.cyan
            case .green:
                Color.green
            case .orange:
                Color.orange
            case .purple:
                Color.purple
            case .red:
                Color.red
        }
    }
    
    static func shapeStyle(forCustomAccentColor custom: CustomAccentColor) -> any ShapeStyle {
        switch custom {
            case .indigo:
                Color.indigo
            case .yellow:
                Color.yellow
            case .pink:
                Color.pink
            case .blue:
                Color.blue
            case .brown:
                Color.brown
            case .cyan:
                Color.cyan
            case .green:
                Color.green
            case .orange:
                Color.orange
            case .purple:
                Color.purple
            case .red:
                Color.red
        }
    }
}
