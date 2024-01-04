//
//  HomeView.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 1/2/24.
//

import SwiftUI
import CoreLocation
import SwiftData
import MapKit

struct HomeView: View {
    @AppStorage(Utility.dataMigratedFromUIKit) var hasMigratedUserData = false
    @AppStorage("shouldUseHaptics") var shouldUseHaptics = true
    @Environment(\.modelContext) var modelContext
    @Query var spots: [ParkingSpot]
    @State private var position: MapCameraPosition = .automatic
    @ObservedObject var locationModel = LocationModel()
    
    @State private var selectedSpot: ParkingSpot?
    @State private var isShowingSpotDetail = false
    
    @State private var locationError: LocationError?
    @State private var isShowingLocationError = false
    
    @State private var isShowingSettings = false
    
    @State private var successHaptic = false
    @State private var secondaryHaptic = false
    
    var body: some View {
        ZStack {
            Map(position: $position) {
                UserAnnotation()
                
                if let spot = selectedSpot {
                    Annotation("Parking Spot", coordinate: spot.coordinate) {
                        ParkingSpotAnnotationLabel(spot: spot) { spot in
                            selectedSpot = spot
                            withAnimation(.bouncy) {
                                isShowingSpotDetail = true
                            }
                        }
                    }
                }
            }
            .mapStyle(.standard)
        }
        .overlay(alignment: .bottom, content: {
            HStack {
                Button {
                    withAnimation {
                        zoomOut()
                    }
                    if shouldUseHaptics {
                        secondaryHaptic.toggle()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .foregroundStyle(.thickMaterial)
                            .shadow(radius: 5)
                        Image(systemName: "arrow.left.and.right.circle.fill")
                            .resizable().scaledToFit()
                            .padding(8)
                    }
                    .frame(width: 44)
                }
                .buttonStyle(AddButtonStyle())
                .padding()
                .accessibilityLabel(Text("Zoom to see both user location and parking spot"))
                .sensoryFeedback(.increase, trigger: secondaryHaptic)
                
                Spacer()
                
                Button {
                    withAnimation {
                        setParkingSpot()
                        zoomOut()
                    }
                    if shouldUseHaptics {
                        successHaptic.toggle()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .foregroundStyle(.thickMaterial)
                            .shadow(radius: 5)
                        Image(systemName: "plus.circle.fill")
                            .resizable().scaledToFit()
                            .padding()
                    }
                    .frame(width: 88)
                }
                .buttonStyle(AddButtonStyle())
                .accessibilityLabel(Text("Park Here"))
                .sensoryFeedback(.success, trigger: successHaptic)
                
                Spacer()
                
                Button {
                    withAnimation {
                        position = .automatic
                    }
                    if shouldUseHaptics {
                        secondaryHaptic.toggle()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .foregroundStyle(.thickMaterial)
                            .shadow(radius: 5)
                        Image(systemName: "car.circle.fill")
                            .resizable().scaledToFit()
                            .padding(8)
                    }
                    .frame(width: 44)
                }
                .buttonStyle(AddButtonStyle())
                .padding()
                .accessibilityLabel(Text("Zoom in to parking spot"))
                .sensoryFeedback(.increase, trigger: secondaryHaptic)
            }
            
        })
        .overlay(alignment: .topLeading, content: {
            Button {
                isShowingSettings = true
            } label: {
                ZStack {
                    Circle()
                        .foregroundStyle(.thickMaterial)
                        .shadow(radius: 5)
                    Image(systemName: "gear")
                        .resizable().scaledToFit()
                        .padding(11)
                }
                .frame(width: 44)
                .bold()
            }
            .buttonStyle(AddButtonStyle())
            .padding()
        })
        .onAppear { setup() }
        .sheet(isPresented: $isShowingSpotDetail, content: {
            if let selectedSpot {
                SpotDetailView(spot: selectedSpot)
            }
        })
        .sheet(isPresented: $isShowingSettings, content: {
            SettingsView()
        })
        .onChange(of: spots) { _, _ in
            selectedSpot = mostRecentSpot()
        }
        .alert(isPresented: $isShowingLocationError, error: locationError) {}
        .onChange(of: locationModel.authorizationStatus) { _, newValue in
            print("^^ status changed \(newValue)")
            switch newValue {
                case .denied:
                    locationError = .badAuthorization
                    isShowingLocationError = true
                case .restricted:
                    locationError = .badAuthorization
                    isShowingLocationError = true
                default:
                    setup()
            }
        }
    }
    
    
    
    func setup() {
        locationModel.requestAuthorization(always: false)
        
        if !hasMigratedUserData {
            if let oldData = checkForOldData() {
                let oldSpot = ParkingSpot(latitude: oldData.location.coordinate.latitude, longitude: oldData.location.coordinate.longitude)
                modelContext.insert(oldSpot)
            }
            
            hasMigratedUserData = true
        }
        
        selectedSpot = mostRecentSpot()
        
        zoomOut()
    }
    
    func mostRecentSpot() -> ParkingSpot? {
        let sortedSpots = spots.sorted(by: {$0.date > $1.date})
        if let first = sortedSpots.first {
            return first
        }
        
        return nil
    }
    
    func checkForOldData() -> PRDataItem? {
        if let userData = UserDefaults.standard.data(forKey: "userDataItem") {
            NSKeyedUnarchiver.setClass(PRDataItem.self, forClassName: "Carpark.PRDataItem")
            if let userDataItem = NSKeyedUnarchiver.unarchiveObject(with: userData) as? PRDataItem {
                return userDataItem
            }
        }
        
        return nil
    }
    
    func setParkingSpot() {
        if let userLocation = locationModel.locationManager.location {
            let newSpot = ParkingSpot(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            modelContext.insert(newSpot)
        }
    }
    
    func zoomOut() {
        guard let userCoords = locationModel.locationManager.location?.coordinate, let spotCoords = selectedSpot?.coordinate else { return }
        
        let minLat = min(userCoords.latitude, spotCoords.latitude)
        let minLong = min(userCoords.longitude, spotCoords.longitude)
        let maxLat = max(userCoords.latitude, spotCoords.latitude)
        let maxLong = max(userCoords.longitude, spotCoords.longitude)
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLong + maxLong) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.5,
            longitudeDelta: (maxLong - minLong) * 1.5
        )
        
        position = .region(MKCoordinateRegion(center: center, span: span))
    }
}

#Preview {
    HomeView()
}
