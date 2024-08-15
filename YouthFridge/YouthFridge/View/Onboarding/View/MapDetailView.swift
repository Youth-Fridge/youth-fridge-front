//
//  MapDetailView.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/5/24.
//

import SwiftUI
import MapKit

struct MapDetailView: View {
    @ObservedObject var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var trackingMode = MapUserTrackingMode.follow
    @Environment(\.presentationMode) var presentationMode
    @State private var showLocationDeletePopup = false
    @State private var certifiedRegions: [MKCoordinateRegion] = []
    var onCertification: (String, String) -> Void
    
    var body: some View {
        ZStack {
            VStack {
                GeometryReader { geometry in
                    Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $trackingMode)
                        .frame(height: geometry.size.height * 0.9) 
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
                    if locationManager.userCity == "천안시" && (locationManager.userDistrict == "동작구" || locationManager.userDistrict == "서북구") {
                        certifiedRegions.append(region)
                        onCertification(locationManager.userCity, locationManager.userDistrict)
                        print("지역이 인증되었습니다.")
                        print(certifiedRegions)
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showLocationDeletePopup = true
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
            if showLocationDeletePopup {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showLocationDeletePopup = false
                        }
                    }
                
                PopUpView(
                    message: "천안시 동작구 또는 서북구만\n 인증할 수 있습니다.",
                    onClose: {
                        withAnimation {
                            showLocationDeletePopup = false
                        }
                    },
                    onConfirm: {
                        withAnimation {
                            showLocationDeletePopup = false
                        }
                    },
                    onCancel: {
                        withAnimation {
                            showLocationDeletePopup = false
                        }
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(1)
            }
        }
        .navigationBarTitle("우리 동네 인증", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }){
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        })
    }
}
