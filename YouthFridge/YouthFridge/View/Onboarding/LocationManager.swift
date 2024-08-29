//
//  LocationManager.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/25/24.
//

import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var userCity: String = ""
    @Published var userDistrict: String = ""
    
    private var hasRequestedGeocode = false // Geocode 요청 플래그
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        requestLocationPermission()
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            startUpdatingLocation()
        } else {
            stopUpdatingLocation()
            // 권한이 없는 경우 대체 처리를 수행할 수 있음
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            self.userLocation = location
            
            if !hasRequestedGeocode {
                hasRequestedGeocode = true
                let geocoder = CLGeocoder()
                let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    if let placemark = placemarks?.first {
                        self.userCity = placemark.locality ?? "알 수 없음"
                        self.userDistrict = placemark.subLocality ?? "알 수 없음"
                    }
                }
            }
        }
    }
}

