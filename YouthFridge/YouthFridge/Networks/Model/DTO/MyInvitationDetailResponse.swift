//
//  MyInvitationDetailResponse.swift
//  YouthFridge
//
//  Created by 임수진 on 8/11/24.
//

import Foundation

struct MyInvitationDetailResponse: Codable {
    let totalMember: Int
    let currentMember: Int
    let memberInfoList: [MemberInfoList]

}

struct MemberInfoList: Codable, Identifiable {
    let id = UUID()
    let nickName: String
    let profileNumber: Int
}
