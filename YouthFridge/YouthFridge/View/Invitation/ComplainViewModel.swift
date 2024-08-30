//
//  ComplainViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/30/24.
//

import Foundation
import SwiftUI

class ComplainViewModel: ObservableObject {
    @Published var categories: [String] = []
    @Published var showComplainPopupView = false
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var showConfirmationAlert = false  // Add this line

    private let selectedCategoryKey = "selectedComplain"
    
    func loadCategories() {
        self.categories = [
            "적절하지 않은 주제의 모임입니다.",
            "욕설/혐오/비속어가 포함되어 있습니다.",
            "모임의 세부 활동에 문제가 있습니다.",
            "모임의 장소에 문제가 있습니다.",
            "모임의 오픈채팅방에 문제가 있습니다.",
            "기타"
        ]
    }
    
    func saveSelectedCategories(_ selectedIndices: [Int], invitationId: Int) {
        let incrementedIndices = selectedIndices.map { $0 + 1 }
        UserDefaults.standard.set(incrementedIndices, forKey: selectedCategoryKey)
        UserDefaults.standard.synchronize()
        
        reportInvitation(invitationId: invitationId, reasonList: incrementedIndices)
    }

    private func reportInvitation(invitationId: Int, reasonList: [Int]) {
        InvitationService.shared.reportInvitation(invitationId: invitationId, reasonList: reasonList) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self.showConfirmationAlert = true // Show alert on success
                    print("소모임 신고가 완료되었습니다")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    if error.localizedDescription == "이미 신고하였습니다." {
                        self.alertTitle = "오류"
                        self.alertMessage = "이미 신고한 소모임입니다."
                        self.showAlert = true
                    } else {
                        self.alertTitle = "오류"
                        self.alertMessage = "신고에 실패했습니다. 다시 시도해 주세요."
                        self.showAlert = true
                    }
                }
            }
        }
    }
}
