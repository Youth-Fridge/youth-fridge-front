//
//  MyInvitationResponse.swift
//  YouthFridge
//
//  Created by 임수진 on 8/1/24.
//

import Foundation

struct MyInvitationResponse: Codable {
    let invitationId: Int
    let emojiNumber: Int
    let clubName: String
    let launchDate: String
    let launchPlace: String
    let startTime: String
}
