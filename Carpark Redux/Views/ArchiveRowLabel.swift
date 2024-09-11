//
//  ArchiveRowLabel.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 6/13/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct ArchiveRowLabel: View {
    @ObservedObject private var locationModel = LocationModel()
    let spot: ParkingSpot
    @State private var placemark: CLPlacemark?
    
    
    var body: some View {
        
        HStack {
            Map(bounds: .init(minimumDistance: 650, maximumDistance: 650)) {
                Marker("", systemImage: "car.fill", coordinate: spot.coordinate)
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 100)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            
            
            VStack(alignment: .leading) {
                Text(spot.displayDate)
                    .fontWeight(.semibold)

                Text(placemark?.subLocality != nil ? placemark!.subLocality! : placemark?.locality != nil ? placemark!.locality! : "")
            }
        }
        
        .task {
            self.placemark = try? await locationModel.placemark(forLocation: CLLocation(latitude: spot.latitude, longitude: spot.longitude))
        }
    }
}

#Preview {
    List {
        ArchiveRowLabel(spot: Utility.exampleSpot)
    }
    .fontDesign(.rounded)
}
