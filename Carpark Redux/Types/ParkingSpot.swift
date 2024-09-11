import Foundation
import SwiftData
import CoreLocation
import AppIntents

@Model
class ParkingSpot: Identifiable {
    let id = UUID()
    let date = Date.now
    let latitude: Double = 0
    let longitude: Double = 0
    var notes: String = ""
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.notes = ""
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    var displayDate: String {
        let lastDayDigit = Calendar.current.component(.day, from: self.date) % 10
        var daySuffix = ""
        switch lastDayDigit {
            case 1:
                daySuffix = "st"
            case 2:
                daySuffix = "nd"
            case 3:
                daySuffix = "rd"
            default:
                daySuffix = "th"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d'\(daySuffix)' yyyy 'at' h:mm a"
        
        return formatter.string(from: self.date)
    }
}
