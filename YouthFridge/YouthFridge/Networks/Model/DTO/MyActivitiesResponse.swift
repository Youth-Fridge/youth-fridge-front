//
//  MyActivitiesResponse.swift
//  YouthFridge
//
//  Created by 임수진 on 8/11/24.
//

import Foundation

struct MyActivitiesResponse: Codable {
    let invitationId: Int
    let emojiNumber: Int
    let clubName: String
    let launchDate: String
    let launchPlace: String
    let startTime: String
}
