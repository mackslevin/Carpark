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
    
    var body: some View {
        VStack {
            Text(spot.date.formatted())
                .font(.largeTitle)
                .bold()
            
            Map {
                Marker(spot.date.formatted(), coordinate: spot.coordinate)
            }
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .padding()
    }
}

#Preview {
    SpotDetailView(spot: Utility.exampleSpot)
}
