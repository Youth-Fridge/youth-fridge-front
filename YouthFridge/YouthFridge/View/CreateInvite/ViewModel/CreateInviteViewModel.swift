//
//  CreateInviteViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/26/24.
//
import SwiftUI

class CreateInviteViewModel: ObservableObject {
    @Published var selectedTab = 0
    @Published var meetingName: String = ""
    @Published var activityPlans: [String] = [""]
    @Published var selectedKeywords: Set<String> = []
    @Published var meetingRoom: String = ""
    @Published var meetingParticipants: Int = 1
    let keywords = ["건강식", "취미", "요리", "장보기", "메뉴 추천", "식단", "운동", "독서", "레시피", "배달", "과제", "기타"]

    func addActivityPlan() {
        if activityPlans.count < 3 {
            activityPlans.append("")
        }
    }

    func toggleKeyword(_ keyword: String) {
        if selectedKeywords.contains(keyword) {
            selectedKeywords.remove(keyword)
        } else {
            if selectedKeywords.count < 2 {
                selectedKeywords.insert(keyword)
            }
        }
    }
}
