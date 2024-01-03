//
//  ParkingSpot.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 1/2/24.
//

import Foundation
import SwiftData
import CoreLocation

@Model
class ParkingSpot: Identifiable {
    let id = UUID()
    let date = Date.now
    let latitude: Double
    let longitude: Double
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
