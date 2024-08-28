//
//  HomeViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var daysRemaining = 0
    @Published var tabContents: [TabContent] = []
    @Published var showPlaceholder: Bool = false
    @Published var profileImageUrl: Int?
    @Published var newsTitle: String = ""
    @Published var newsUrl: String = ""
    
    let publicMeetingBackground = ["banner2", "banner1", "banner3"] //banner1 :김장 ,banner2: 포트락 파티
    init() {
        fetchCards()
        fetchPublicMeeting()
        fetchInvitationData()
        fetchUserProfile()
        fetchLatestNewsUrl()
    }
    
    func fetchUserProfile() {
        OnboardingAPI.shared.userInfo { [weak self] result in
            switch result {
            case .success(let userInfoResponse):
                self?.profileImageUrl = userInfoResponse.profileImageNumber
                UserDefaults.standard.set(userInfoResponse.nickname, forKey: "nickname")
                UserDefaults.standard.set(userInfoResponse.profileImageNumber, forKey: "profileImageNumber")
            case .failure(let error):
                print("Failed to fetch user info: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchPublicMeeting() {
        HomeService.shared.fetchPublicMeetingThree { [weak self] result in
            switch result {
            case .success(let publicMeetings):
                DispatchQueue.main.async {
                    self?.tabContents = publicMeetings.enumerated().map { index, publicMeeting in
                        let formattedDate = DateFormatter.date(from: publicMeeting.launchDate, formatter: .launchDateFormatter)
                            .map { DateFormatter.displayPublicDateFormatter.string(from: $0) } ?? publicMeeting.launchDate
                        
                        return TabContent(
                            invitationId: publicMeeting.invitationId,
                            title: publicMeeting.title,
                            date: formattedDate,
                            ing: publicMeeting.isRecruiting ? "모집 중" : "모집완료",
                            imageName: self?.publicMeetingBackground[index % self!.publicMeetingBackground.count] ?? "defaultImage"
                        )
                    }
                }
            case .failure(let error):
                print("Error fetching public meetings: \(error)")
            }
        }
    }
    
    func fetchCards() {
        HomeService.shared.fetchTopFiveInvitations { [weak self] result in
            switch result {
            case .success(let invitations):
                DispatchQueue.main.async {
                    if invitations.isEmpty {
                        self?.showPlaceholder = true
                    } else {
                        self?.cards = invitations.map { invitation in
                            Card(
                                id: invitation.id,
                                name: invitation.ownerInfo.ownerName,
                                title: invitation.name,
                                location: invitation.launchPlace,
                                tags: invitation.interests,
                                emojiNumber: invitation.emojiNumber,
                                profileImageNumber: invitation.ownerInfo.profileImageNumber,
                                startTime: invitation.startTime,
                                endTime: invitation.endTime,
                                launchDate: invitation.launchDate
                            )
                        }
                    }
                }
            case .failure(let error):
                print("Error fetching invitations: \(error)")
            }
        }
    }
    
    private func fetchInvitationData() {
        InvitationService.shared.getImminentInvitation { [weak self] result in
            switch result {
            case .success(let response):
                if let response = response {
                    // 신청한 소모임이 있는 경우
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    let launchDateString = response.launchDate
                    if let targetDate = dateFormatter.date(from: launchDateString) {
                        let currentDate = Date()
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.day], from: currentDate, to: targetDate)
                        let dayLeft = components.day ?? 0
                        
                        DispatchQueue.main.async {
                            self?.daysRemaining = dayLeft
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.daysRemaining = -1
                    }
                }
            case .failure(let error):
                // 신청한 소모임이 1개도 없는 경우
                DispatchQueue.main.async {
                    self?.daysRemaining = -1
                }
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func performAction() {
        print("Button pressed in view model")
    }
    
    private func fetchLatestNewsUrl() {
        NewsLetterService.shared.getNewsLetter { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.newsTitle = response.title
                    self.newsUrl = response.link
                }
            case .failure(let error):
                print("Failed to fetch URL: \(error.localizedDescription)")
            }
        }
    }
}
