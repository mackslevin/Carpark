import Foundation
import CoreLocation

class LocationModel: NSObject, ObservableObject {
    @Published var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        self.locationManager.delegate = self
    }

    public func requestAuthorization(always: Bool = false) {
        if always {
            self.locationManager.requestAlwaysAuthorization()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    @MainActor
    func placemark(forLocation location: CLLocation) async throws -> CLPlacemark? {
        let geocoder = CLGeocoder()
        if let placemark = try await geocoder.reverseGeocodeLocation(location).first {
            return placemark
        }
        
        return nil
    }
}

extension LocationModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
    }
}
