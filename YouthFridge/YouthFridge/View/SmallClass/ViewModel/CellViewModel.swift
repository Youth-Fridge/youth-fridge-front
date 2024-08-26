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
        if currentPage == 0 {
            self.cells.removeAll()  // 기존 데이터를 초기화
        }
        
        canLoadMore = true
        
        InvitationService.shared.getInvitationList(page: currentPage, size: 5) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let invitations):
                    print("Received 최신순: \(invitations)")
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
    
    func observeSelectedTags(_ selectedTagsSubject: PassthroughSubject<[String], Never>) {
        selectedTagsSubject
            .sink { [weak self] newTags in
                guard let self = self else { return }
                
                // 태그가 비어있을 경우 초기화 후 기존 데이터를 다시 불러옴
                self.currentPage = 0
                self.canLoadMore = true
                if newTags.isEmpty {
                    self.cells.removeAll() // 기존 데이터 초기화
                    self.fetchInviteCellData()
                } else {
                    self.fetchKeyWordsList(selectedTags: newTags)
                }
            }
            .store(in: &cancellables)
    }
    
    
    func fetchKeyWordsList(selectedTags: [String]) {
        let keywords = selectedTags.joined(separator: ",")
        
        InvitationService.shared.getInvitationKeyWords(keywords: keywords, page: 0, size: 10) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let invitations):
                    print("Received invitations: \(invitations)")
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
}





