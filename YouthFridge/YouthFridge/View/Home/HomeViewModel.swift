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

    @Published var tabContents: [TabContent] = []
    let publicMeetingBackground = ["banner1", "banner2", "banner3"]
    init() {
        fetchCards()
        fetchPublicMeeting()
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
                            ing: publicMeeting.isRecruiting ? "모집중" : "모집완료",
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
            case .failure(let error):
                print("Error fetching invitations: \(error)")
            }
        }
    }

    func performAction() {
        print("Button pressed in view model")
    }
}
