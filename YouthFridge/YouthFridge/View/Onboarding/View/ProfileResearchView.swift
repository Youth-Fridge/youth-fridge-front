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
    @State private var isShowingProfileSelector = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var trackingMode: MapUserTrackingMode = .follow
    @State private var selectedProfileImage = "Ellipse20"
    
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
                VStack {
                    Image(selectedProfileImage)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                    Button(action: {
                        isShowingProfileSelector.toggle()
                    }) {
                        Image("onboardingCamera")
                            .resizable()
                            .frame(width: 40,height: 40)
                    }
                    .padding(.top,-45)
                    .padding(.leading,70)
                    
                }
                Spacer()
                HStack(spacing: 0) {
                    Text("닉네임")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("사용 가능한 닉네임입니다.")
                        .font(.system(size: 12))
                        .foregroundColor(.main1Color)
                }
                .padding(.horizontal)
                
                HStack {
                    
                    TextField("6글자 이내", text: $nickname)
                        .padding(.leading,10)
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
                    .padding(10)
                    
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.main1Color, lineWidth: 1)
                )
                .padding(.horizontal)
                
                .sheet(isPresented: $isShowingProfileSelector) {
                    ProfilePictureSelector(selectedImage: $selectedProfileImage, isShowing: $isShowingProfileSelector)
                        .presentationDetents([.medium, .large])
                }
                .animation(.easeInOut, value: isShowingProfileSelector)
                Spacer()
                Text("한 줄 소개")
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                TextField("15글자 이내 *ex: 365일 식단 조절러", text: $introduceMe)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Spacer()
                Text("우리 동네 인증하기")
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                Button(action: {
                    // 버튼 클릭 시 동작 추가
                }) {
                    HStack {
                        Image("locationImage")
                            .resizable()
                            .frame(width: 16, height: 22)
                        
                        VStack(alignment: .leading) {
                            Text("천안시 동작구")
                                .font(.system(size: 12,weight: .medium))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    }
                    .padding(7)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.main1Color, lineWidth: 1)
                    )
                    NavigationLink(destination: MapDetailView(region: $region, trackingMode: $trackingMode)) {
                        Text("우리 동네 인증")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.main1Color)
                            .cornerRadius(10)
                    }
                    
                }
                Spacer()
                    NavigationLink(destination: StartView().navigationBarBackButtonHidden()) {
                        Text("다음")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 320)
                            .background(Color.yellow)
                            .cornerRadius(8)
                    }
                    .padding()
                    
                    .onAppear {
                        //updateCurrentLocation()
                    }
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                
            }
            
        }
        
        //    private func updateCurrentLocation() {
        //        let locationManager = CLLocationManager()
        //        locationManager.requestWhenInUseAuthorization()
        //
        //        if CLLocationManager.locationServicesEnabled() {
        //            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //            locationManager.startUpdatingLocation()
        //
        //            if let location = locationManager.location?.coordinate {
        //                self.userLocation = location
        //                self.region = MKCoordinateRegion(
        //                    center: location,
        //                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        //                )
        //            }
        //        }
        //    }
    }
    

struct MapDetailView: View {
    @ObservedObject var locationManager = LocationManager()
    @Binding var region: MKCoordinateRegion
    @Binding var trackingMode: MapUserTrackingMode
    
    @State private var certifiedRegions: [MKCoordinateRegion] = []
    @State private var userCity: String = ""
    @State private var userDistrict: String = ""
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $trackingMode)
                    .frame(height: geometry.size.height * 0.9) // Adjust height as needed
                    .cornerRadius(10)
                    .padding()
            }
            .frame(maxHeight: .infinity)
            
            Text("내 동네")
                .font(.system(size: 25, weight: .bold))
                .padding()
            
            Text("현재 위치: \(locationManager.userCity) \(locationManager.userDistrict)")
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
}

    
    #Preview {
        ProfileResearchView()
    }

