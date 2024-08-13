//
//  InvitationDetailResponse.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/12/24.
//

import Foundation

struct InvitationDetailResponse: Codable {
    let invitationId: Int
    let clubName: String
    let invitationImageNumber: Int
    let ownerInfo : OwnerInfo
    let launchDate : String
    let startTime: String
    let endTime: String
    let launchPlace : String
    let totalMember: Int
    let currentMember: Int
    let toDoList: [String]
}

