import SwiftUI
import StoreKit
import SwiftData

struct SettingsView: View {
    @AppStorage("shouldUseHaptics") var shouldUseHaptics = true
    @AppStorage("mapPreference") var mapPreference: MapPreference = .standard
    @AppStorage("customAccentColor") var customAccentColor: CustomAccentColor = .indigo
    @AppStorage("shouldConfirmBeforeParking") var shouldConfirmBeforeParking = false
    @AppStorage("settingsWasOpenedCounter") var openedCounter = 0 // Incremented on view appear. Eventually reset to zero. Used in determining when to prompt for app store review/rating.
    
    @Environment(\.requestReview) private var requestReview
    @Environment(\.dismiss) var dismiss
    
    @State private var vm = SettingsViewModel()
    
    @Query var spots: [ParkingSpot]
    
    
    let storeKitClient: StoreKitClient = .init()
    
    var body: some View {
        NavigationStack {
            List {
                Section("Defaults") {
                    
                    Picker("Map Style", selection: $mapPreference) {
                        ForEach(MapPreference.allCases) { mapPref in
                            Text(mapPref.rawValue.capitalized).tag(mapPref)
                        }
                    }
                    Toggle("Haptic Feedback", isOn: $shouldUseHaptics)
                    Toggle("Confirm Before Setting Parking Space", isOn: $shouldConfirmBeforeParking)
                }
                
                Section("Accent Color") {
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
                    NavigationLink("📆 Past Parking Spots") {
                        ArchiveView()
                    }
                    .disabled(spots.count < 2)
                }
                
                Section("In-App Purchase") {
                    NavigationLink("🤑 Tip Jar", destination: ShopView())
                }
            }
            .fontWeight(.medium)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .background {
                Rectangle()
                    .foregroundStyle(.tint)
                    .ignoresSafeArea()
                    .opacity(0.05)
            }
            .onAppear {
                if vm.shouldAskForReview() {
                    requestReview()
                }
                
                Task {
                    let p = await storeKitClient.products
                    let names = p.map({$0.displayName}).joined(separator: " - ")
                    print("^^ \(names)")
                }
            }
            .presentationDragIndicator(.visible)
        }
    }
}

//#Preview {
//    SettingsView()
//}
