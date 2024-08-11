//
//  MyApplicationViewModel.swift
//  YouthFridge
//
//  Created by 임수진 on 7/23/24.
//

import Foundation
import SwiftUI

class MyApplicationViewModel: ObservableObject {
    @Published var activities: [ActivityCardViewModel]
    var participantsList: [User] = [
        User(name: "임수진", profilePicture: "Ellipse"),
        User(name: "김민솔", profilePicture: "Ellipse"),
        User(name: "최강", profilePicture: "Ellipse"),
        User(name: "임수진", profilePicture: "Ellipse"),
        User(name: "김민솔", profilePicture: "Ellipse"),
        User(name: "최강", profilePicture: "Ellipse")
    ]
    
    init() {
        self.activities = [
//            ActivityCardViewModel(title: "카레 장보기", date: "8월 1일 일요일", location: "안서마트", daysLeft: 21, imageName: "image1", participants: participantsList),
//            ActivityCardViewModel(title: "브런치 갈 사람?", date: "7월 31일 수요일", location: "피넛츠", daysLeft: 8, imageName: "image1", participants: participantsList),
//            ActivityCardViewModel(title: "단대호수 빵 투어", date: "6월 5일 월요일", location: "단대 호수 주차장 앞", daysLeft: 0, imageName: "image", isPast: true),
//            ActivityCardViewModel(title: "냉면 만들기 파", date: "6월 1일 수요일", location: "안서 동보아파트", daysLeft: 0, imageName: "image1", isPast: true)
        ]
    }
}
