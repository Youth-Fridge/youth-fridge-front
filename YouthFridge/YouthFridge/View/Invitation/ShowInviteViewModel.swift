//
//  ShowInviteViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/12/24.
//

import Foundation
import Combine

class ShowInviteViewModel: ObservableObject {
    @Published var showDetail: ShowDetailModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func fetchInviteData(invitationId: Int) {
        InvitationService.shared.getInvitationDetail(invitationId: invitationId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let invitationDetail):
                    if let launchDate = DateFormatter.launchDateFormatter.date(from: invitationDetail.launchDate) {
                        let today = Date()
                        let dDay = Calendar.current.dateComponents([.day], from: today, to: launchDate).day ?? 0
                        
                        let formattedDetail = ShowDetailModel(
                            invitationId: invitationDetail.invitationId,
                            clubName: invitationDetail.clubName,
                            dday: "\(dDay)",
                            number: "\(invitationDetail.currentMember)/\(invitationDetail.totalMember)",
                            time: "\(invitationDetail.startTime) ~ \(invitationDetail.endTime)",
                            place: invitationDetail.launchPlace,
                            todo: invitationDetail.toDoList.joined(separator: "\n"),
                            ownerProfile: invitationDetail.ownerInfo.profileImageNumber,
                            invitationImage: invitationDetail.invitationImageNumber
                        )
                        self?.showDetail = formattedDetail
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

