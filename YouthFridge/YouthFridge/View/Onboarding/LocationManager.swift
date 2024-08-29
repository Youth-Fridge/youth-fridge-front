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
    @Published var userSubLocality: String = ""
    
    private var hasRequestedGeocode = false // Geocode 요청 플래그
    
    // 동남구와 서북구의 동 리스트 정의
    private let dongNamGu = [
        "대흥동", "성황동", "문화동", "사직동", "영성동", "오룡동", "원성동", "구성동", "청수동",
        "삼룡동", "청당동", "유량동", "봉명동", "다가동", "용곡동", "쌍용동", "신부동", "신방동",
        "안서동", "구룡동", "중앙동", "문성동", "원성1동", "원성2동", "일봉동", "청룡동", "신안동"
    ]
    
    private let seoBukGu = [
        "와촌동", "성정동", "백석동", "두정동", "성성동", "차암동", "쌍용동", "불당동", "업성동",
        "신당동", "부대동", "성정1동", "성정2동", "쌍용1동", "쌍용2동", "쌍용3동", "불당1동",
        "불당2동", "부성1동", "부성2동"
    ]
    
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
                    if let error = error {
                        print("Geocoding error: \(error.localizedDescription)")
                    } else if let placemark = placemarks?.first {
                        // 전체 placemark 정보 확인
                        print("Placemark: \(placemark)")
                        
                        // 도시 및 구역 정보 설정
                        self.userCity = placemark.locality ?? "알 수 없음"
                        
                        // 구역 및 동 정보 설정
                        if let subLocality = placemark.subLocality {
                            self.userDistrict = subLocality
                        } else if let addressDictionary = placemark.addressDictionary as? [String: Any] {
                            if let subLocality = addressDictionary["SubLocality"] as? String {
                                self.userDistrict = subLocality
                            } else {
                                self.userDistrict = placemark.locality ?? "알 수 없음"
                            }
                        } else {
                            self.userDistrict = placemark.locality ?? "알 수 없음"
                        }
                        
                        self.userSubLocality = placemark.thoroughfare ?? placemark.subThoroughfare ?? "알 수 없음"
                        
                        // 디버깅을 위한 추가 정보 확인
                        print("City: \(self.userCity), District: \(self.userDistrict), SubLocality: \(self.userSubLocality)")
                        print("Thoroughfare: \(placemark.thoroughfare ?? "알 수 없음")")
                        print("SubThoroughfare: \(placemark.subThoroughfare ?? "알 수 없음")")
                    }
                }
            }
        }
    }
    
    func isInAuthorizedArea() -> Bool {
        let authorizedCities = ["천안시"]
      //  let authorizedDistricts = ["동남구", "서북구"]
        
        let isAuthorizedCity = authorizedCities.contains(userCity)
        
        let isAuthorizedDistrict = dongNamGu.contains(userDistrict) || seoBukGu.contains(userDistrict)
                                    
        
        return isAuthorizedCity && isAuthorizedDistrict
    }
}
