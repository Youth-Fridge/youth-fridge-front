//
//  CellViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/20/24.
//

import SwiftUI
import Combine

class CellViewModel: ObservableObject {
    @Published var cells: [CellModel] = []
    private var currentPage: Int = 0
    private var canLoadMore: Bool = true
    
    private var cancellables = Set<AnyCancellable>()

    func fetchInviteCellData() {
        InvitationService.shared.getInvitationList(page: currentPage, size: 5) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let invitations):
                    if !invitations.isEmpty {
                        let newCells = invitations.map { invitation in
                            CellModel(id: invitation.invitationId,
                                      image: "invitationImage\(invitation.emojiNumber)",
                                      title: invitation.clubName,
                                      tag: invitation.interests,
                                      ing: invitation.currentMember < invitation.totalMember ? "모집 중" : "모집 완료",
                                      numberOfPeople: "\(invitation.currentMember)/\(invitation.totalMember)")
                        }
                        
                        self.cells.append(contentsOf: newCells)
                        self.currentPage += 1
                        
                        if newCells.count < 5 {
                            self.canLoadMore = false
                        }
                    } else {
                        self.canLoadMore = false
                    }
                case .failure(let error):
                    print("Error loading invitations: \(error.localizedDescription)")
                }
            }
        }
    }

    func fetchKeyWordsList(selectedTags: [String]) {
        let keywords = selectedTags.joined(separator: ",")
        
        InvitationService.shared.getInvitationKeyWords(keywords: keywords, page: 0, size: 10) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let invitations):
                    self.cells = invitations.map { invitation in
                        CellModel(id: invitation.invitationId,
                                  image: "invitationImage\(invitation.emojiNumber)",
                                  title: invitation.clubName,
                                  tag: invitation.interests,
                                  ing: invitation.currentMember < invitation.totalMember ? "모집 중" : "모집 완료",
                                  numberOfPeople: "\(invitation.currentMember)/\(invitation.totalMember)")
                    }
                    self.currentPage = 1
                    self.canLoadMore = invitations.count >= 5
                case .failure(let error):
                    print("Error loading invitations: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func observeSelectedTags(_ selectedTagsSubject: PassthroughSubject<[String], Never>) {
        selectedTagsSubject
            .sink { [weak self] newTags in
                guard let self = self else { return }
                if newTags.isEmpty {
                    self.currentPage = 0
                    self.cells.removeAll()
                    self.canLoadMore = true
                    self.fetchInviteCellData()
                } else {
                    self.cells.removeAll()
                    self.fetchKeyWordsList(selectedTags: newTags)
                }
            }
            .store(in: &cancellables)
    }

}




