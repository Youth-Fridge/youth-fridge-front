//
//  MyInvitationResponse.swift
//  YouthFridge
//
//  Created by 임수진 on 8/1/24.
//

import Foundation

struct MyInvitationResponse: Codable {
    let invitationId: Int
    let previewImage: String
    let clubName: String
    let launchDate: String
    let launchPlace: String
    
    enum CodingKeys: String, CodingKey {
        case invitationId = "invitation_id"
        case previewImage = "preview_image"
        case clubName = "club_name"
        case launchDate = "launch_date"
        case launchPlace = "launch_place"
    }
}
