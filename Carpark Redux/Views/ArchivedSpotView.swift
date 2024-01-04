//
//  ArchivedSpotView.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 1/3/24.
//

import SwiftUI
import MapKit
import SwiftData

struct ArchivedSpotView: View {
    @Bindable var spot: ParkingSpot
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    
    @State private var placemark: CLPlacemark? = nil
    @State private var showNotesEvenThoughEmpty = false
    @State private var isShowingDeleteWarning = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    
                    Text(placemark?.name == nil ? "Parking Spot, \(spot.date.formatted())" : "Near \(placemark!.name!)")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.accent)
                    
                    Text(placemark?.subLocality != nil ? placemark!.subLocality! : placemark?.locality != nil ? placemark!.locality! : "")
                        .foregroundStyle(.secondary)
                        .fontWeight(.medium)
                    Map {
                        Marker(spot.date.formatted(), systemImage: "car.fill", coordinate: spot.coordinate)
                    }
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
                    if spot.notes.isEmpty && !showNotesEvenThoughEmpty {
                        Button {
                            withAnimation {
                                showNotesEvenThoughEmpty = true
                            }
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
                        isShowingDeleteWarning = true
                    } label: {
                        HStack {
                            Spacer()
                            Label("Delete Parking Spot", systemImage: "trash")
                            Spacer()
                        }
                    }
                    .bold()
                    .buttonStyle(.borderedProminent)
                }
                .padding(.vertical)
                
                
                Spacer()
            }
            .navigationTitle(spot.date.formatted())
            .multilineTextAlignment(.center)
            .padding()
            .fontDesign(.rounded)
            .background {
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundStyle(colorScheme == .light ? Color.accentColor : Color.clear)
                    .opacity(0.05)
            }
            .task {
                await setPlacemark()
            }
            .alert("Are you sure you want to delete this spot?", isPresented: $isShowingDeleteWarning) {
                Button(role: .destructive) {
                    delete()
                } label: {
                    Text("Delete")
                }
            } message: {
                Text("This action cannot be undone. If there is a previous parking spot, that spot will now be displayed instead.")
            }
        }
        
    }
    
    func setPlacemark() async {
        let location = CLLocation(latitude: spot.latitude, longitude: spot.longitude)
        let geocoder = CLGeocoder()
        if let placemark = try? await geocoder.reverseGeocodeLocation(location).first {
            self.placemark = placemark
        }
    }
    
    func delete() {
        modelContext.delete(spot)
        dismiss()
    }
}

//#Preview {
//    ArchivedSpotView()
//}