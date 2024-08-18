//
//  MyPageViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import Foundation
import SwiftUI

class MyPageViewModel: ObservableObject {
    @Published var myUser: User?
    @Published var launchDate: String?
    @Published var startTime: String?
    let type = UserDefaults.standard.string(forKey: "loginType") ?? ""
    private var container: DIContainer
    let bigProfileImages = ["bigBrocoli", "bigPea", "bigCorn", "bigTomato", "bigBranch", "bigPumpkin"]
    init(container: DIContainer) {
        self.container = container
        fetchUserData()
        fetchInvitationData()
    }
    
    private func fetchUserData() {
        let selectedImageIndex = getSelectedImageIndex()
        let nicknameKey = type == "apple" ? "appleUserNickname" : "kakaoUserNickname"
        
        // 가져온 닉네임을 'nickname'이라는 키로 저장
        let nickname = UserDefaults.standard.string(forKey: nicknameKey) ?? "Unknown"                
        let profileImage = (selectedImageIndex >= 0 && selectedImageIndex <= bigProfileImages.count)
            ? bigProfileImages[selectedImageIndex]
            : "defaultBigProfile"
        
        myUser = User(name: nickname, profilePicture: profileImage)
    }
    
    private func getSelectedImageIndex() -> Int {
        let profileImageKey = type == "apple" ? "appleProfileImageNumber" : type == "kakao" ? "kakaoProfileImageNumber" : "profileImageNumber"
        let profileImageNumber = UserDefaults.standard.integer(forKey: profileImageKey)
        return profileImageNumber
    }
    
    private static func convertDate(from dateString: String) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = inputDateFormatter.date(from: dateString) else { return "Invalid date" }
        
        return DateFormatter.displayDateFormatter.string(from: date)
    }
    
    private static func convertTime(from timeString: String) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "HH:mm:ss"

        guard let date = inputDateFormatter.date(from: timeString) else { return "Invalid time" }
        
        return DateFormatter.displayTimeFormatter.string(from: date)
    }
    
    private func fetchInvitationData() {
        InvitationService.shared.getImminentInvitation { [weak self] result in
            switch result {
            case .success(let response):
                // 신청한 소모임이 있는 경우
                if let response = response {
                    let launchDate = MyPageViewModel.convertDate(from: response.launchDate)
                    let startTime = MyPageViewModel.convertTime(from: response.startTime)
                    
                    DispatchQueue.main.async {
                        self?.launchDate = launchDate
                        self?.startTime = startTime
                    }
                } else {
                    // 신청한 소모임이 1개도 없는 경우
                    DispatchQueue.main.async {
                        self?.launchDate = nil
                        self?.startTime = nil
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
