//
//  LocationManager.swift
//  weather
//
//  Created by Kito on 8/1/22.
//

import CoreLocation

final class LocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    
    var location: CLLocationCoordinate2D?
    var currentCityName: String?
    
    var didGetLocation: ((_ lat: Double, _ lon: Double) -> Void)?
    
    var showError: ((_ title: String, _ message: String) -> Void)?
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways,.authorizedWhenInUse:
            if let location = location {
                didGetLocation?(location.latitude, location.longitude)
            }
             else {
                locationManager.requestLocation()
            }
        default:
            break
        }
    }
    
    private func getPlace(location: CLLocation?) {
        
        let geocoder = CLGeocoder()
        guard let location =  location else { return }
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                return
            }
            
            self.currentCityName = placemark.locality
        }
    }
}
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showError?("Location error", "Can not get your location")
        print("Error is ", error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {

            self.location = location
            self.getPlace(location: locations.first)
            self.didGetLocation?(location.latitude, location.longitude)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.requestLocation()
    }
}
