import SwiftUI
import MapKit

struct Utility {
    
    // User defaults key for first run of the SwiftUI (post-UIKit) version of the app. It's a bool we set to true after any old user data has been migrated.
    static let dataMigratedFromUIKit = "dataHasBeenMigratedFromUIKitVersion"
    
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
    

    func isAccentColorSystemYellow() -> Bool {
        let accentUIColor = UIColor(Color.accentColor)
        let systemYellow = UIColor.systemYellow

        // Compare the RGB components of both colors
        var accentRed: CGFloat = 0, accentGreen: CGFloat = 0, accentBlue: CGFloat = 0, accentAlpha: CGFloat = 0
        accentUIColor.getRed(&accentRed, green: &accentGreen, blue: &accentBlue, alpha: &accentAlpha)

        var yellowRed: CGFloat = 0, yellowGreen: CGFloat = 0, yellowBlue: CGFloat = 0, yellowAlpha: CGFloat = 0
        systemYellow.getRed(&yellowRed, green: &yellowGreen, blue: &yellowBlue, alpha: &yellowAlpha)

        // Check if RGB components are the same (or very close, due to minor float differences)
        let tolerance: CGFloat = 0.01
        return abs(accentRed - yellowRed) < tolerance &&
               abs(accentGreen - yellowGreen) < tolerance &&
               abs(accentBlue - yellowBlue) < tolerance
    }

}
