import SwiftUI
import SwiftData

@main
struct Carpark_ReduxApp: App {
    @AppStorage(StorageKeys.customAccentColor.rawValue) var customAccentColor: CustomAccentColor = .indigo

    var body: some Scene {
        WindowGroup {
            HomeView()
                .tint(Utility.color(forCustomAccentColor: customAccentColor))
                .fontDesign(.rounded)
                .environment(\.storeKitClient, StoreKitClient())
        }
        .modelContainer(DataCenter.shared.container)
    }
}



