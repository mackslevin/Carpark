import SwiftUI
import MapKit
import CoreLocation

struct ParkingSpotAnnotationLabel: View {
    let spot: ParkingSpot
    let onTap: (ParkingSpot) -> Void
    
    var body: some View {
        Button {
            onTap(spot)
        } label: {
            ZStack {
                Circle()
                    .foregroundStyle(.regularMaterial)
                    .shadow(radius: 3)
                Image(systemName: "car.fill")
                    .resizable().scaledToFit()
                    .padding(12)
                    .foregroundStyle(.tint)
            }
            .frame(width: 50)
        }
    }
}

#Preview {
    ParkingSpotAnnotationLabel(spot: Utility.exampleSpot, onTap: {_ in})
}
