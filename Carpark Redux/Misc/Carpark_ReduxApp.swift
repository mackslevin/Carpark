import SwiftUI
import SwiftData

@main
struct Carpark_ReduxApp: App {
    var sharedModelContainer: ModelContainer = {
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
    
    @AppStorage("customAccentColor") var customAccentColor: CustomAccentColor = .indigo

    var body: some Scene {
        WindowGroup {
            HomeView()
                .tint(Utility.color(forCustomAccentColor: customAccentColor))
                .fontDesign(.rounded)
        }
        .modelContainer(sharedModelContainer)
    }
}
