//
//  Invitation.swift
//  YouthFridge
//
//  Created by 임수진 on 8/9/24.
//

import Foundation

struct Invitation: Codable {
    let name: String
    let launchDate: String
    let startTime: String
    let endTime: String
    let kakaoLink: String
    let launchPlace: String
    let emojiNumber: Int
    let totalMember: Int
    let imageNumber: Int
    let activityPlans: [String]
    let interests: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case launchDate = "launch_date"
        case startTime = "start_time"
        case endTime = "end_time"
        case kakaoLink = "kakao_link"
        case launchPlace = "launch_place"
        case emojiNumber = "emoji_number"
        case totalMember = "total_member"
        case imageNumber = "image_number"
        case activityPlans = "activity_plans"
        case interests
    }

    init(name: String, launchDate: String, startTime: String, endTime: String, kakaoLink: String, launchPlace: String, emojiNumber: Int, totalMember: Int, imageNumber: Int, activityPlans: [String], interests: [String]) {
        self.name = name
        self.launchDate = launchDate
        self.startTime = startTime
        self.endTime = endTime
        self.kakaoLink = kakaoLink
        self.launchPlace = launchPlace
        self.emojiNumber = emojiNumber
        self.totalMember = totalMember
        self.imageNumber = imageNumber
        self.activityPlans = activityPlans
        self.interests = interests
    }
}
