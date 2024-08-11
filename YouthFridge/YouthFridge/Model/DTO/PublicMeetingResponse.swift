//
//  PublicMeetingResponse.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/10/24.
//

import Foundation

struct PublicMeetingResponse: Codable {
    let invitationId : Int
    let title: String
    let launchDate: String
    let isRecruting: Bool
}
