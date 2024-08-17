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
    @Published var isLoading: Bool = false
    private var currentPage: Int = 0
    private var canLoadMore: Bool = true
    
    private var cancellables = Set<AnyCancellable>()

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
                            CellModel(id: invitation.invitationId,
                                      image: "invitationImage\(invitation.emojiNumber)",
                                      title: invitation.clubName,
                                      tag: invitation.interests,
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

    func observeSelectedTags(_ selectedTagsSubject: PassthroughSubject<[String], Never>) {
        selectedTagsSubject
            .sink { [weak self] newTags in
                if newTags.isEmpty {
                    self?.fetchInviteCellData()
                } else {
                    self?.fetchKeyWordsList(selectedTags: newTags)
                }
            }
            .store(in: &cancellables)
    }
    

    
    func fetchKeyWordsList(selectedTags: [String]) {
        guard !isLoading else { return }
        isLoading = true
        let keywords = selectedTags.joined(separator: ",")
        
        InvitationService.shared.getInvitationKeyWords(keywords: keywords, page: 0, size: 10) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let invitations):
                    self?.cells = invitations.map { invitation in
                        CellModel(id: invitation.invitationId,
                                  image: "invitationImage\(invitation.emojiNumber)",
                                  title: invitation.clubName,
                                  tag: invitation.interests,
                                  ing: invitation.currentMember < invitation.totalMember ? "모집 중" : "모집 완료",
                                  numberOfPeople: "\(invitation.currentMember)/\(invitation.totalMember)")
                    }
                    self?.currentPage = 1
                    self?.canLoadMore = invitations.count >= 5
                case .failure(let error):
                    print("Error loading invitations: \(error.localizedDescription)")
                }
            }
        }
    }
}





