import Foundation

enum MapPreference: String, CaseIterable, Identifiable, Codable {
    case hybrid, imagery, standard
    
    var id: String {
        rawValue
    }
}


