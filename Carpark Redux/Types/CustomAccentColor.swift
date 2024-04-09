import Foundation

enum CustomAccentColor: String, CaseIterable, Identifiable, Codable {
    case indigo, yellow, pink, blue, brown, cyan, green, orange, purple, red
    
    var id: String {
        rawValue
    }
}
