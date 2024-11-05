import SwiftUI
import MapKit

struct Utility {
    @MainActor static let exampleSpot = ParkingSpot(latitude: 34.10325647753972, longitude: -118.31919351426978)
    
    static func mapStyle(forMapPreference mapPreference: MapPreference) -> MapStyle {
        switch mapPreference {
            case .hybrid:
                MapStyle.hybrid
            case .imagery:
                MapStyle.imagery
            case .standard:
                MapStyle.standard(pointsOfInterest: .excludingAll)
        }
    }
    
    static func simpleDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
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
