//
//  ProfileResearchViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/3/24.
//

import SwiftUI
import MapKit
import CoreLocation
import Combine

class ProfileResearchViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var introduceMe: String = ""
    @Published var isShowingProfileSelector: Bool = false
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @Published var nicknameMessage: String = "닉네임을 입력하세요."
    @Published var nicknameMessageColor: Color = Color.main1Color
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var trackingMode: MapUserTrackingMode = .follow
    @Published var selectedProfileImage: String = "original"
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        $nickname
            .sink { [weak self] newValue in
                guard let self = self else { return }
                if newValue.count > 6 {
                    self.nickname = String(newValue.prefix(6))
                    self.alertMessage = "닉네임은 6글자 이내로 입력하세요."
                    self.showAlert = true
                }
            }
            .store(in: &cancellables)
        $introduceMe
                   .sink { [weak self] newValue in
                       guard let self = self else { return }
                       if newValue.count > 15 {
                           self.introduceMe = String(newValue.prefix(15))
                           self.alertMessage = "한 줄 소개는 15글자 이내로 입력해주세요."
                           self.showAlert = true
                       }
                   }
                   .store(in: &cancellables)
    }
    func checkNickname() {
        OnboardingAPI.shared.checkNickname(nickname) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isAvailable):
                    self.nicknameMessage = isAvailable ? "사용 가능한 닉네임 입니다." : "이미 사용 중인 닉네임 입니다."
                    self.nicknameMessageColor = isAvailable ? Color.green : Color.red
                case .failure(_):
                    self.nicknameMessage = "사용 불가능한 닉네임 입니다."
                    self.nicknameMessageColor = Color.red
                }
            }
        }
    }
    
    
    func signUp() {
//        let signupRequest = OnboardingRequest (type: <#T##String#>, email: <#T##String#>, nickname: nickname, introduce: introduceMe, role: <#T##String#>, profileImageNumber: <#T##Int#>, town: <#T##String#>, inquiryNumList: <#T##[Int]#>)
//
//        OnboardingAPI.shared.signUp(signupRequest) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success:
//                    self.alertMessage = "회원가입 성공!"
//                    self.showAlert = true
//                case .failure(let error):
//                    self.alertMessage = "회원가입 실패: \(error.localizedDescription)"
//                    self.showAlert = true
//                }
//            }
//
//        }
    }
}
