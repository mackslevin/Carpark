//
//  LocationError.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 1/3/24.
//

import Foundation

enum LocationError: LocalizedError {
    case badAuthorization
    
    var errorDescription: String? {
        switch self {
            case .badAuthorization:
                "This app is currently not authorized to access the user location, which is required for most of its  functionality. Please grant access in settings in order for things to work as expected."
        }
    }
}
