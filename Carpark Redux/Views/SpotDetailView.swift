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
    
    @State private var nearText: String? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Text(nearText == nil ? "Parking Spot, \(spot.date.formatted())" : "Near \(nearText!)")
                .font(.title)
                .bold()
            
            VStack(alignment: .leading) {
                Map {
                    Marker(spot.date.formatted(), systemImage: "car.fill", coordinate: spot.coordinate)
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                Text("\(spot.latitude), \(spot.longitude)")
                    .foregroundStyle(.secondary)
            }
            
            
            Spacer()
        }
        .multilineTextAlignment(.center)
        .padding()
        .fontDesign(.rounded)
        .task {
            await setNearText()
        }
    }
    
    func setNearText() async {
        let location = CLLocation(latitude: spot.latitude, longitude: spot.longitude)
        let geocoder = CLGeocoder()
        if let placemark = try? await geocoder.reverseGeocodeLocation(location).first {
            nearText = placemark.name
        }
    }
}

#Preview {
    SpotDetailView(spot: Utility.exampleSpot)
}
