//
//  ProfileResearchView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/17/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct ProfileResearchView: View {
    @State private var nickname = ""
    @State private var introduceMe = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var trackingMode: MapUserTrackingMode = .follow

    var body: some View {
        NavigationView {
            VStack {
                ProgressView(value: 1)
                    .progressViewStyle(CustomProgressViewStyle())
                    .padding()
                Text("프로필 설정")
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                Image("Ellipse20")
                    .resizable()
                    .frame(width: 120, height: 120)
                HStack {
                    Text("닉네임")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    Spacer()
                    Text("사용 가능한 닉네임입니다.")
                        .font(.system(size: 12))
                        .foregroundColor(.main1Color)
                        .padding()
                }
                HStack {
                    TextField("6글자 이내", text: $nickname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button(action: {
                        // 중복 확인 액션
                    }) {
                        Text("중복 확인")
                            .font(.system(size: 12))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.main1Color)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .padding()
                }
                Text("한 줄 소개")
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                TextField("10글자 이내", text: $introduceMe)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Text("우리 동네 인증하기")
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                if let userLocation = userLocation {
                    Text("현재 위치: \(userLocation.latitude), \(userLocation.longitude)")
                        .padding()
                }
                
                NavigationLink(destination: MapDetailView(region: $region, trackingMode: $trackingMode)) {
                    Text("우리 동네 인증")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.main1Color)
                        .cornerRadius(10)
                }
                .padding()
                .onAppear {
                    updateCurrentLocation()
                }
            }
            .navigationBarTitle("내 동네 설정", displayMode: .inline)
        }
    }
    
    private func updateCurrentLocation() {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            if let location = locationManager.location?.coordinate {
                self.userLocation = location
                self.region = MKCoordinateRegion(
                    center: location,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            }
        }
    }
}

struct MapDetailView: View {
    @Binding var region: MKCoordinateRegion
    @Binding var trackingMode: MapUserTrackingMode
    
    @State private var certifiedRegions: [MKCoordinateRegion] = []
    @State private var userCity: String = ""
    @State private var userDistrict: String = ""

    var body: some View {
        VStack {
            Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $trackingMode)
                .frame(height: 300)
                .cornerRadius(10)
                .padding()
                .onAppear {
                    updateCurrentLocation()
                }
            
            Text("현재 위치: \(userCity) \(userDistrict)")
                .font(.system(size: 16, weight: .bold))
                .padding()

            Text("인증 지역 : 총 \(certifiedRegions.count)개")
                .font(.system(size: 16, weight: .bold))
                .padding()
            
            Text("최초 1회 인증 시 전국에서 사용 가능합니다.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding()
            
            Button(action: {
                if certifiedRegions.count < 2 {
                    certifiedRegions.append(region)
                } else {
                    // Handle case where more than 2 regions are selected
                }
            }) {
                Text("인증 지역 추가")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.main1Color)
                    .cornerRadius(10)
            }
        }
        .navigationBarTitle("우리 동네 인증", displayMode: .inline)
    }
    
    private func updateCurrentLocation() {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            if let location = locationManager.location?.coordinate {
                let geocoder = CLGeocoder()
                let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    if let placemark = placemarks?.first {
                        self.userCity = placemark.locality ?? ""
                        self.userDistrict = placemark.subLocality ?? ""
                    }
                }
            }
        }
    }
}


#Preview {
    ProfileResearchView()
}
