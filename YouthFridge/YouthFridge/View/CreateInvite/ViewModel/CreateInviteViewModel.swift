//
//  CreateInviteViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/26/24.
//

import SwiftUI
import Combine

class CreateInviteViewModel: ObservableObject {
    @Published var meetingName: String = ""
    @Published var activityPlans: [String] = []
    @Published var selectedKeywords: [String] = []
    @Published var meetingRoom: String = ""
    @Published var meetingParticipants: Int = 1
    @Published var selectedDate: Date = Date()
    @Published var selectedStartTime: String = ""
    @Published var selectedEndTime: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var selectedTab = 0
    let keywords = ["건강식", "취미", "요리", "장보기", "메뉴 추천", "식단", "운동", "독서", "레시피", "배달", "과제", "기타"]

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
        
        let formattedDate = dateFormatter.string(from: selectedDate)
        
        let invitationDTO = Invitation(
            name: meetingName,
            launchDate: formattedDate,
            startTime: selectedStartTime,
            endTime: selectedEndTime,
            kakaoLink: "bb",
            launchPlace: meetingRoom,
            emojiNumber: 1,
            totalMember: meetingParticipants,
            imageNumber: 1,
            activityPlans: activityPlans,
            interests: Array(selectedKeywords)
        )
        
        guard let data = try? JSONEncoder().encode(invitationDTO) else {
            print("Failed to encode invitationDTO")
            return
        }
        
        // Data를 JSON 문자열로 변환해서 출력
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Encoded JSON: \(jsonString)")
        } else {
            print("Failed to convert Data to JSON string")
        }
        
        InvitationService.shared.createInvitation(data: data) { result in
            switch result {
            case .success(let message):
                print(message)
            case .failure(let error):
                print(invitationDTO)
                print("Failed with error: \(error.localizedDescription)")
            }
        }
    }
}

