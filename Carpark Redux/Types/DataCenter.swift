//
//  DataCenter.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 11/5/24.
//

import Foundation
import SwiftData

@MainActor
final class DataCenter {
    static let shared = DataCenter()
    let container: ModelContainer
    
    init() {
        self.container = {
            let schema = Schema([
                ParkingSpot.self,
                InAppPurchase.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, cloudKitDatabase: .private("iCloud.com.johnslevin.Carpark"))

            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
    }
}
