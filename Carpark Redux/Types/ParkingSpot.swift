//
//  ParkingSpot.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 1/2/24.
//

import Foundation
import SwiftData
import CoreLocation
import AppIntents

@Model
class ParkingSpot: Identifiable {
    let id = UUID()
    let date = Date.now
    let latitude: Double = 0
    let longitude: Double = 0
    var notes: String = ""
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.notes = ""
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
