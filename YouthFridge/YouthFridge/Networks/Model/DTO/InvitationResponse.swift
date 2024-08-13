//
//  InvitationResponse.swift
//  YouthFridge
//
//  Created by 임수진 on 8/1/24.
//

import Foundation

struct InvitationResponse: Codable {
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
