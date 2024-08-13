//
//  InvitationListResponse.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/13/24.
//

import Foundation

struct InvitationListResponse: Codable {
    let invitationId: Int
    let clubName: String
    let interests: [String]
    let totalMember: Int
    let currentMember: Int
    let emojiNumber: Int
}
