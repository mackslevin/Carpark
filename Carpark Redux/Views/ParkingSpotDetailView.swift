import SwiftUI
import MapKit
import SwiftData

struct ParkingSpotDetailView: View {
    @Bindable var spot: ParkingSpot
    
    @FocusState var notesFieldIsFocused: Bool
    @ObservedObject var locationModel = LocationModel()
    @State private var vm = ParkingSpotDetailViewModel()
    
    @AppStorage(StorageKeys.mapPreference.rawValue) var mapPreference: MapPreference = .standard
    @AppStorage(StorageKeys.customAccentColor.rawValue) var customAccentColor: CustomAccentColor = .indigo
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text(vm.placemark?.name == nil ? "Parking Spot, \(spot.date.formatted())" : "Near \(vm.placemark!.name!)")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.tint)
                        
                        Text(vm.placemark?.subLocality != nil ? vm.placemark!.subLocality! : vm.placemark?.locality != nil ? vm.placemark!.locality! : "")
                            .foregroundStyle(.secondary)
                            .fontWeight(.medium)
                        Map {
                            Marker(spot.date.formatted(), systemImage: "car.fill", coordinate: spot.coordinate)
                        }
                        .mapStyle(Utility.mapStyle(forMapPreference: mapPreference))
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        
                        
                        Menu {
                            Button("Copy Coordinates") {
                                UIPasteboard.general.string = "\(spot.latitude), \(spot.longitude)"
                            }
                        } label: {
                            Text("\(spot.latitude), \(spot.longitude)")
                        }
                        .tint(.secondary)
                    }
                    .multilineTextAlignment(.leading)
                    
                    VStack(spacing: 12) {
                        if spot.notes.isEmpty && !vm.showNotesEvenThoughEmpty {
                            Button {
                                withAnimation {
                                    vm.showNotesEvenThoughEmpty = true
                                }
                                notesFieldIsFocused = true
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Add Notes")
                                        .bold()
                                    Spacer()
                                }
                            }
                            .buttonStyle(.bordered)
                        } else {
                            VStack(alignment: .leading) {
                                Text("Notes")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                                TextField("...", text: $spot.notes, axis: .vertical)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.leading)
                                    .focused($notesFieldIsFocused)
                                    .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            Spacer()
                                            Button("Done") {
                                                notesFieldIsFocused = false
                                            }
                                            .bold()
                                        }
                                    }
                            }
                            .padding(.bottom)
                        }
                        
                        Button {
                            if let url = URL(string: "maps://?saddr=&daddr=\(spot.latitude),\(spot.longitude)") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Label("Get Directions", systemImage: "arrow.triangle.turn.up.right.circle")
                                Spacer()
                            }
                        }
                        .buttonStyle(.bordered)
                        .bold()
                        
                        if let url = URL(string: "http://maps.apple.com/?ll=\(spot.latitude),\(spot.longitude)") {
                            ShareLink(item: url) {
                                HStack {
                                    Spacer()
                                    Label("Share Location", systemImage: "square.and.arrow.up")
                                    Spacer()
                                }
                                .bold()
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        Button(role: .destructive) {
                            vm.isShowingDeleteWarning = true
                        } label: {
                            HStack {
                                Spacer()
                                Label("Delete Parking Spot", systemImage: "trash")
                                Spacer()
                            }
                        }
                        .bold()
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                    .padding(.vertical)
                    
                    
                    Spacer()
                }
                .navigationTitle("Parking Spot")
                .navigationBarTitleDisplayMode(.inline)
                .multilineTextAlignment(.center)
                .padding()
                .task {
                    vm.placemark = try? await locationModel.placemark(forLocation: CLLocation(latitude: spot.latitude, longitude: spot.longitude))
                }
                .alert("Are you sure you want to delete this spot?", isPresented: $vm.isShowingDeleteWarning) {
                    Button(role: .destructive) {
                        modelContext.delete(spot)
                        dismiss()
                    } label: {
                        Text("Delete")
                    }
                } message: {
                    Text("This action cannot be undone. If there is a previous parking spot, that spot will now be displayed instead.")
                }
            }
            .background {
                Rectangle()
                    .fill(colorScheme == .light ? Utility.color(forCustomAccentColor: customAccentColor) : Color.clear)
                    .ignoresSafeArea()
                    .opacity(0.05)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done").bold()
                    }
                }
            }
        }
    }
}

//#Preview {
//    ArchivedSpotView()
//}
