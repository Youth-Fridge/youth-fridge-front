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
    
    @State private var certifiedRegions: [MKCoordinateRegion] = []
    var onCertification: (String, String) -> Void
    
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
                    onCertification(locationManager.userCity, locationManager.userDistrict)
                    print("지역이 인증되었습니다.")
                    print(certifiedRegions)
                    presentationMode.wrappedValue.dismiss()
                } else {
                    print("더 이상 인증할 수 없습니다.")
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
