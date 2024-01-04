//
//  MapPreference.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 1/4/24.
//

import Foundation

enum MapPreference: String, CaseIterable, Identifiable, Codable {
    case hybrid, imagery, standard
    
    var id: String {
        rawValue
    }
}


