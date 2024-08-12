//
//  InvitationTopFiveResponse.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/6/24.
//

import Foundation

struct InvitationTopFiveResponse: Codable {
    let id: Int
    let name: String
    let emojiNumber: Int
    let ownerInfo: OwnerInfo
    let interests: [String]
    let launchPlace: String
    let launchDate: String
    let startTime: String
    let endTime: String
    
}

struct OwnerInfo: Codable {
    let ownerId: Int
    let ownerName: String
    let profileImageNumber: Int
}
