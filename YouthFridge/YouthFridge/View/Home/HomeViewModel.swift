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

    @Published var tabContents = [
        TabContent(imageName: "banner1", title: "우리 같이 미니 김장할래?", content: "김: 김치 만들고\n치: 치~ 인구 할래? 끝나고 웃놀이 한 판!", date: "10월 5일", ing: "모집중"),
        TabContent(imageName: "banner2", title: "포트락 파티에 널 초대할게", content: "각자 먹고 싶은거 가져와 다 함께\n 나눠먹는 ,,,,그런거 있잖아요~", date: "9월 12일", ing: "모집중"),
        TabContent(imageName: "banner3", title: "특별한 뱅쇼와 함께 하는 연말 파티", content: "제철과일로 만드는\n 뱅쇼와 함께 도란도란 이야기 나눠요 ", date: "11월 2일", ing: "모집중")
    ]

    init() {
        fetchCards()
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
