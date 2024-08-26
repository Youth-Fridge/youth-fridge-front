//
//  CreateInviteViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/26/24.
//

import SwiftUI
import Combine

class CreateInviteViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var activityPlans: [String] = ["", ""]
    @Published var selectedKeywords: [String] = []
    @Published var launchPlace: String = ""
    @Published var totalMember: Int = 0
    @Published var launchDate: Date = Date()
    @Published var selectedStartTime: String = ""
    @Published var selectedEndTime: String = ""
    @Published var kakaoLink: String = ""
    @Published var emojiNumber: Int = -1
    @Published var imageNumber: Int = -1
    @Published var selectedTab: Int = 0
    @Published var profileImageUrl: Int?
    @Published var nickname: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    let keywords = ["건강식", "취미", "요리", "장보기", "메뉴 추천", "식단", "운동", "독서", "레시피", "배달", "과제", "기타"]
    
    // 유효성 검사 함수
    var isFormComplete: Bool {
        return !name.trimmingCharacters(in: .whitespaces).isEmpty &&
               activityPlans.count >= 1 && activityPlans.count <= 3 &&
               activityPlans.allSatisfy { !$0.trimmingCharacters(in: .whitespaces).isEmpty } &&
               !selectedKeywords.isEmpty &&
               selectedKeywords.count >= 1 && selectedKeywords.count <= 2 &&
               !launchPlace.trimmingCharacters(in: .whitespaces).isEmpty &&
               (totalMember > 0 && totalMember <= 8) &&
               !selectedStartTime.trimmingCharacters(in: .whitespaces).isEmpty &&
               !selectedEndTime.trimmingCharacters(in: .whitespaces).isEmpty &&
               !kakaoLink.trimmingCharacters(in: .whitespaces).isEmpty &&
               (emojiNumber > -1 && emojiNumber <= 11) &&
               (imageNumber > -1 && imageNumber <= 5)
    }

    func addActivityPlan() {
        if activityPlans.count < 3 {
            activityPlans.append("")
        }
    }

    func toggleKeyword(_ keyword: String) {
        if selectedKeywords.contains(keyword) {
            if let index = selectedKeywords.firstIndex(of: keyword) {
                selectedKeywords.remove(at: index)
            }
        } else {
            if selectedKeywords.count < 2 {
                selectedKeywords.append(keyword)
            }
        }
    }
    
    func createInvitation() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedLaunchDate = dateFormatter.string(from: launchDate)
        
        let invitationDTO = InvitationResponse(
            name: name,
            launchDate: formattedLaunchDate,
            startTime: selectedStartTime,
            endTime: selectedEndTime,
            kakaoLink: kakaoLink,
            launchPlace: launchPlace,
            emojiNumber: emojiNumber,
            totalMember: totalMember,
            imageNumber: imageNumber,
            activityPlans: activityPlans,
            interests: Array(selectedKeywords)
        )
        
        guard let data = try? JSONEncoder().encode(invitationDTO) else { return }
        
        InvitationService.shared.createInvitation(data: data) { result in
            switch result {
            case .success(let message):
                print(message)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchProfileImage() {
        OnboardingAPI.shared.userInfo { [weak self] result in
            switch result {
            case .success(let userInfoResponse):
                self?.nickname = userInfoResponse.nickname
                self?.profileImageUrl = userInfoResponse.profileImageNumber
            case .failure(let error):
                print("Failed to fetch user info: \(error.localizedDescription)")
            }
        }
    }
}

