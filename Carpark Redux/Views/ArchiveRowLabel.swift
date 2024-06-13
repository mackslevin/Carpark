//
//  ArchiveRowLabel.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 6/13/24.
//

import SwiftUI
import CoreLocation

struct ArchiveRowLabel: View {
    @ObservedObject private var locationModel = LocationModel()
    let spot: ParkingSpot
    @State private var placemark: CLPlacemark?
    
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d'th' yyyy 'at' h:mm a"
        return dateFormatter.string(from: spot.date)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(formattedDate)
                .fontWeight(.semibold)

            Text(placemark?.subLocality != nil ? placemark!.subLocality! : placemark?.locality != nil ? placemark!.locality! : "")
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
