//
//  MyAppliedInvitationDetailResponse.swift
//  YouthFridge
//
//  Created by 임수진 on 8/11/24.
//

import Foundation

struct MyAppliedInvitationDetailResponse: Codable {
    let totalMember: Int
    let currentMember: Int
    let ownerProfileImageNumber: Int
    let ownerIntroduce: String
    let activities: [String]
    let kakaoLink: String
}
