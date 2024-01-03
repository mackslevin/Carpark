//
//  Carpark_ReduxApp.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 1/2/24.
//

import SwiftUI
import SwiftData

@main
struct Carpark_ReduxApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ParkingSpot.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
