//
//  SettingsView.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 1/4/24.
//

import SwiftUI



struct SettingsView: View {
    @AppStorage("shouldUseHaptics") var shouldUseHaptics = true
    @AppStorage("mapPreference") var mapPreference: MapPreference = .standard
    @AppStorage("customAccentColor") var customAccentColor: CustomAccentColor = .indigo
    @AppStorage("shouldConfirmBeforeParking") var shouldConfirmBeforeParking = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Defaults") {
                    
                    Picker("Map Style", selection: $mapPreference) {
                        ForEach(MapPreference.allCases) { mapPref in
                            Text(mapPref.rawValue.capitalized).tag(mapPref)
                        }
                    }
                    .tint(.primary)
                    
                    
                    Toggle("Haptic Feedback", isOn: $shouldUseHaptics)
                    
                    Toggle("Confirm Before Setting Parking Space", isOn: $shouldConfirmBeforeParking)
                }
                
                Section("Appearance") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), content: {
                        ForEach(CustomAccentColor.allCases) { color in
                            ZStack {
                                Circle()
                                    .opacity(0.8)
                                Circle()
                                    .fill(Utility.color(forCustomAccentColor: color).gradient)
                                    .padding(color.id == customAccentColor.id ? 8 : 0)
                            }
                            .onTapGesture(perform: {
                                withAnimation {customAccentColor = color}
                            })
                            .tint(.primary)
                        }
                    })
                }
                
                Section("Data") {
                    NavigationLink("Past Parking Spots") {
                        ArchiveView()
                    }
                }
                
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .background {
                Rectangle()
                    .foregroundStyle(.tint)
                    .ignoresSafeArea()
                    .opacity(0.05)
            }
        }
    }
}

#Preview {
    SettingsView()
}
