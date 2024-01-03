//
//  SpotDetailView.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 1/2/24.
//

import SwiftUI
import MapKit

struct SpotDetailView: View {
    @Bindable var spot: ParkingSpot
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    
    @State private var nearText: String? = nil
    @State private var showNotesEvenThoughEmpty = false
    @State private var isShowingDeleteWarning = false
    
    var body: some View {
        VStack(spacing: 20){
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body).bold()
                    }
                }
                
                Text(nearText == nil ? "Parking Spot, \(spot.date.formatted())" : "Near \(nearText!)")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.accent)
            }
            
            
            VStack(alignment: .leading) {
                Map {
                    Marker(spot.date.formatted(), systemImage: "car.fill", coordinate: spot.coordinate)
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                Text("\(spot.latitude), \(spot.longitude)")
                    .foregroundStyle(.secondary)
            }
            
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
                }
                
                Button {
                    
                } label: {
                    HStack {
                        Spacer()
                        Label("Get Directions", systemImage: "arrow.triangle.turn.up.right.circle")
                        Spacer()
                    }
                }
                .buttonStyle(.bordered)
                .bold()
                
                Button(role: .destructive) {
                    isShowingDeleteWarning = true
                } label: {
                    HStack {
                        Spacer()
                        Label("Delete Spot", systemImage: "trash")
                        Spacer()
                    }
                }
                .bold()
                .buttonStyle(.borderedProminent)
            }
            .padding(.vertical)
            
            
            Spacer()
        }
        .multilineTextAlignment(.center)
        .padding()
        .fontDesign(.rounded)
        .background {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(colorScheme == .light ? Color.accentColor : Color.black)
                .opacity(colorScheme == .light ? 0.05 : 1)
        }
        .task {
            await setNearText()
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
    
    func setNearText() async {
        let location = CLLocation(latitude: spot.latitude, longitude: spot.longitude)
        let geocoder = CLGeocoder()
        if let placemark = try? await geocoder.reverseGeocodeLocation(location).first {
            nearText = placemark.name
        }
    }
    
    func delete() {
        modelContext.delete(spot)
        dismiss()
    }
}

#Preview {
    SpotDetailView(spot: Utility.exampleSpot)
}
