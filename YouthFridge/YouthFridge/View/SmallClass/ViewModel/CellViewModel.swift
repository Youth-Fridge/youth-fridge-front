//
//  CellViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/20/24.
//

import SwiftUI

class CellViewModel: ObservableObject {
    @Published var cells: [CellModel] = []
    @Published var isLoading: Bool = false
    private var currentPage: Int = 0
    private var canLoadMore: Bool = true
    
    func fetchInviteCellData() {
        guard !isLoading && canLoadMore else { return }
        isLoading = true
        
        InvitationService.shared.getInvitationList(page: currentPage, size: 5) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let invitations):
                    if !invitations.isEmpty {
                        let newCells = invitations.map { invitation in
                            CellModel(image: "invitationImage\(invitation.emojiNumber)",
                                      title: invitation.clubName,
                                      tag: invitation.interests.joined(separator: ", "),
                                      ing: invitation.currentMember < invitation.totalMember ? "모집 중" : "모집 완료",
                                      numberOfPeople: "\(invitation.currentMember)/\(invitation.totalMember)")
                        }
                        
                        self?.cells.append(contentsOf: newCells)
                        self?.currentPage += 1
                    } else {
                        self?.canLoadMore = false
                    }
                case .failure(let error):
                    print("Error loading invitations: \(error.localizedDescription)")
                }
            }
        }
    }
}



