//
//  ActivityDetailModel.swift
//  YouthFridge
//
//  Created by 임수진 on 8/11/24.
//

import Foundation

class ActivityDetailModel: ObservableObject, Identifiable {
    @Published var totalMember: Int
    @Published var currentMember: Int
    @Published var memberInfoList: [MemberInfoList]
    @Published var invitationActivities: [ActivityCardViewModel] = []
    
    private let invitationId: Int

    init(invitationId: Int) {
        self.invitationId = invitationId
        self.totalMember = 0
        self.currentMember = 0
        self.memberInfoList = []
        fetchDetailActivities()
    }
    
    func fetchDetailActivities() {
        InvitationService.shared.getMyDetailInvitation(invitationId: invitationId) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.totalMember = response.totalMember
                    self?.currentMember = response.currentMember
                    self?.memberInfoList = response.memberInfoList
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
