//
//  CustomAccentColor.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 1/4/24.
//

import Foundation

enum CustomAccentColor: String, CaseIterable, Identifiable, Codable {
    case indigo, yellow, pink, blue, brown, cyan, green, orange, purple, red
    
    var id: String {
        rawValue
    }
}
