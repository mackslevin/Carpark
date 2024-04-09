import Foundation
import AppIntents
import SwiftData

struct ParkHere: AppIntent {
    static var title: LocalizedStringResource = "Park Here"

    enum ParkHereError: Swift.Error, CustomLocalizedStringResourceConvertible {
        case noLocation
        
        var localizedStringResource: LocalizedStringResource {
            switch self {
                case .noLocation:
                    return "Location unavailable"
            }
        }
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        // Get user location
        let locationModel = LocationModel()
        locationModel.requestAuthorization()
        
        if let location = locationModel.locationManager.location {
            print("^^ location \(location)")
            
            // Create model container to interact with SwiftData database
            let sharedModelContainer: ModelContainer = {
                let schema = Schema([
                    ParkingSpot.self,
                ])
                let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, cloudKitDatabase: .private("iCloud.com.johnslevin.Carpark"))

                do {
                    return try ModelContainer(for: schema, configurations: [modelConfiguration])
                } catch {
                    fatalError("Could not create ModelContainer: \(error)")
                }
            }()
            
            // Save new spot for current location
            let newSpot = ParkingSpot(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            sharedModelContainer.mainContext.insert(newSpot)
        } else {
            print("^^ no location")
            throw ParkHereError.noLocation
        }
        
        return .result()
    }
}
