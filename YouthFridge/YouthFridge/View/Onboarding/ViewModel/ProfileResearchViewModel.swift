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
    @Published var nickname: String = "" {
            didSet {
                UserDefaults.standard.set(nickname, forKey: "nickname")
        }
    }
    @Published var introduceMe: String = ""
    @Published var isShowingProfileSelector: Bool = false
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    @Published var nicknameMessage: String = "닉네임을 입력하세요."
    @Published var nicknameMessageColor: Color = Color.main1Color
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var trackingMode: MapUserTrackingMode = .follow
    @Published var selectedProfileImage: String = "bigBrocoli"
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var userCity: String = ""
    @Published var userDistrict: String = ""
    @Published var isNicknameChecked: Bool = false

    var isNextButtonEnabled: Bool {
        !nickname.isEmpty && !introduceMe.isEmpty && !userCity.isEmpty && !userDistrict.isEmpty && isNicknameChecked
    }
    private var cancellables = Set<AnyCancellable>()

    init() {
       if let savedNickname = UserDefaults.standard.string(forKey: "nickname") {
           self.nickname = savedNickname
       }
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
            print(self.nickname)
            DispatchQueue.main.async {
                switch result {
                case .success(let isAvailable):
                    self.isNicknameChecked = isAvailable
                    self.nicknameMessage = isAvailable ? "사용 가능한 닉네임 입니다." : "이미 사용 중인 닉네임 입니다."
                    self.nicknameMessageColor = isAvailable ? Color.main1Color : Color.red
                case .failure(_):
                    self.isNicknameChecked = false
                    self.nicknameMessage = "사용 불가능한 닉네임 입니다."
                    self.nicknameMessageColor = Color.red
                }
            }
        }
    }
    
    
    func signUp() {
        let selectedCategoryKey = "selectedCategories"
        let email = UserDefaults.standard.string(forKey: "userEmail") ?? "default@default.com"
        let type = UserDefaults.standard.string(forKey: "loginType") ?? "unknown"
        let username = UserDefaults.standard.string(forKey: "userID") ?? "unknown"
        let inquiryNumList = UserDefaults.standard.array(forKey: selectedCategoryKey) as? [Int] ?? []
        let profileImageNumber = UserDefaults.standard.integer(forKey: "profileImageNumber")
        let signupRequest = OnboardingRequest (type: type, email: email, username: username, nickname: nickname, introduce: introduceMe, role: "ROLE_USER", profileImageNumber: profileImageNumber, town: "동남구", inquiryNumList: inquiryNumList)

        OnboardingAPI.shared.signUp(signupRequest) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.alertMessage = "회원가입 성공!"
                    self.showAlert = true
                case .failure(let error):
                    self.alertMessage = "회원가입 실패: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }

        }
    }
}
