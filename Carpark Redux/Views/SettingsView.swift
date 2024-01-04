//
//  SettingsView.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 1/4/24.
//

import SwiftUI

enum MapPreference: String, CaseIterable, Identifiable, Codable {
    case hybrid, imagery, standard
    
    var id: String {
        rawValue
    }
}

struct SettingsView: View {
    @AppStorage("shouldUseHaptics") var shouldUseHaptics = true
    @AppStorage("mapPreference") var mapPreference: MapPreference = .standard
    
    var body: some View {
        NavigationStack {
            List {
                
                
                Section {
                    
                    Picker("Map Style", selection: $mapPreference) {
                        ForEach(MapPreference.allCases) { mapPref in
                            Text(mapPref.rawValue.capitalized).tag(mapPref)
                        }
                    }
                    
                    Toggle("Haptic Feedback", isOn: $shouldUseHaptics)
                }
                
                NavigationLink("Past parking spots") {
                    ArchiveView()
                }
                
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
