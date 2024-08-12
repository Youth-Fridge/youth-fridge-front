//
//  ApplicationDetailModel.swift
//  YouthFridge
//
//  Created by 임수진 on 8/12/24.
//

import Foundation
import Combine

class ApplicationDetailModel: ObservableObject, Identifiable {
    @Published var totalMember: Int
    @Published var currentMember: Int
    @Published var ownerProfileImageNumber: Int
    @Published var ownerIntroduce: String
    @Published var activities: [String]
    @Published var kakaoLink: String
    @Published var invitationActivities: [ActivityCardViewModel] = []
    @Published var isCancelled: Bool
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let invitationId: Int

    init(invitationId: Int) {
        self.invitationId = invitationId
        self.totalMember = 0
        self.currentMember = 0
        self.ownerProfileImageNumber = 0
        self.ownerIntroduce = ""
        self.activities = []
        self.kakaoLink = ""
        self.isCancelled = false
        fetchDetailActivities()
    }
    
    func fetchDetailActivities() {
        InvitationService.shared.getMyApplicationDetail(invitationId: invitationId) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.totalMember = response.totalMember
                    self?.currentMember = response.currentMember
                    self?.ownerProfileImageNumber = response.ownerProfileImageNumber
                    self?.ownerIntroduce = response.ownerIntroduce
                    self?.activities = response.activities
                    self?.kakaoLink = response.kakaoLink
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func cancelInvitation() {
        InvitationService.shared.cancelInvitation(invitationId: invitationId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { message in
                self.isCancelled = (message == "ExpectedSuccessMessage")
            })
            .store(in: &cancellables)
    }
}
