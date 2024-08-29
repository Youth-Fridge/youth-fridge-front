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
    @Published private(set) var isLoading = false
    private var currentPage: Int = 0
    private var canLoadMore: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
    // 데이터를 초기화하는 메서드
    func resetData() {
        self.cells.removeAll()
        self.currentPage = 0
        self.canLoadMore = true
    }
    
    func fetchInviteCellData() {
        guard canLoadMore && !isLoading else { return }
        isLoading = true
        
        InvitationService.shared.getInvitationList(page: currentPage, size: 5) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
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
                        
                        self.canLoadMore = newCells.count >= 5
                    } else {
                        self.canLoadMore = false
                    }
                case .failure(let error):
                    print("Error loading invitations: \(error.localizedDescription)")
                    self.canLoadMore = true  // 에러 발생 시 다시 로드 가능하도록 설정
                }
            }
        }
    }
    
    func observeSelectedTags(_ selectedTagsSubject: PassthroughSubject<[String], Never>) {
        selectedTagsSubject
            .removeDuplicates() // Ignore duplicate tag selections
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main) // Throttle input to avoid rapid state changes
            .sink { [weak self] newTags in
                guard let self = self else { return }
                
                self.resetData()  // 데이터를 초기화합니다.
                if newTags.isEmpty {
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
                    self.canLoadMore = true  // 에러 발생 시 다시 로드 가능하도록 설정
                }
            }
        }
    }
}





