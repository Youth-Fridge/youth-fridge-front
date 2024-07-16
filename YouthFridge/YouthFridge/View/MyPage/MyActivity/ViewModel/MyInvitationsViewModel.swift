//
//  MyInvitationsViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import Foundation
import SwiftUI

class MyInvitationsViewModel: ObservableObject {
    @Published var activities: [ActivityCardViewModel]
    
    init() {
        self.activities = [
            ActivityCardViewModel(title: "스시 먹부림", date: "7월 30일 화요일", location: "안서초등학교", daysLeft: 10, imageName: "image1"),
            ActivityCardViewModel(title: "냉면 만들기 파", date: "6월 1일 수요일", location: "안서 동보아파트", daysLeft: 0, imageName: "naengmyeon", isPast: true)
        ]
    }
}

