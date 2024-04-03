//
//  ParkHere.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 4/2/24.
//

import Foundation
import AppIntents

struct ParkHere: AppIntent {
    
    
    static var title: LocalizedStringResource = "Park Here"
    
    func perform() async throws -> some IntentResult {
        
        let locationModel = LocationModel()
        locationModel.requestAuthorization()
        
        if let location = locationModel.locationManager.location {
            print("^^ location \(location)")
        } else {
            print("^^ no location")
        }
        
        return .result()
    }
    
}
