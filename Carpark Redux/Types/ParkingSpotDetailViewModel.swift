//
//  ParkingSpotDetailViewModel.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 9/9/24.
//

import SwiftUI
import Observation
import MapKit

@Observable
class ParkingSpotDetailViewModel {
    var placemark: CLPlacemark? = nil
    var showNotesEvenThoughEmpty = false
    var isShowingDeleteWarning = false
}
