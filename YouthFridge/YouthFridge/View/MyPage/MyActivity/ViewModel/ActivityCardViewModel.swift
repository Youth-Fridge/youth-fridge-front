//
//  ActivityCardViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import Foundation
import Combine

class ActivityCardViewModel: ObservableObject, Identifiable {
    let id = UUID()
    @Published var invitationId: Int
    @Published var title: String
    @Published var date: String
    @Published var location: String
    @Published var startTime: String
    @Published var daysLeft: Int
    @Published var emojiNumber: Int
    @Published var isPast: Bool
    
    init(invitationId: Int, title: String, date: String, location: String, startTime: String, daysLeft: Int, emojiNumber: Int, isPast: Bool = false) {
        self.invitationId = invitationId
        self.title = title
        self.date = date
        self.location = location
        self.startTime = startTime
        self.daysLeft = daysLeft
        self.emojiNumber = emojiNumber
        self.isPast = isPast
    }
    
    convenience init(from data: MyActivitiesResponse) {
        let daysLeft = ActivityCardViewModel.calculateDaysLeft(from: data.launchDate)
        let launchDate = ActivityCardViewModel.convertDate(from: data.launchDate)
        let startTime = ActivityCardViewModel.convertTime(from: data.startTime)
        
        self .init(
            invitationId: data.invitationId,
            title: data.clubName,
            date: launchDate,
            location: data.launchPlace,
            startTime: startTime,
            daysLeft: daysLeft,
            emojiNumber: data.emojiNumber,
            isPast: daysLeft == 0 ? true : false
        )
    }

    private static func calculateDaysLeft(from dateString: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let targetDate = dateFormatter.date(from: dateString) else {
            return 0
        }
        
        let currentDate = Date()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: currentDate, to: targetDate)
        
        let dayLeft = components.day ?? 0
        return max(dayLeft, 0)
    }
    
    private static func convertDate(from dateString: String) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = inputDateFormatter.date(from: dateString) else { return "Invalid date" }

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "M월 d일"

        return outputDateFormatter.string(from: date)
    }
    
    private static func convertTime(from timeString: String) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "HH:mm:ss"

        guard let date = inputDateFormatter.date(from: timeString) else { return "Invalid time" }

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "H시"

        return outputDateFormatter.string(from: date)
    }
}
