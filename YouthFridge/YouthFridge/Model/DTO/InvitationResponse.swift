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
    let launchPlace: String
    let imojiNumber: Int
    let totalMember: Int
    let imageNumber: Int
    let ownerEmail: String
    let activityPlans: [String]
    let interests: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case launchDate = "launch_date"
        case launchPlace = "launch_place"
        case imojiNumber = "imoji_number"
        case totalMember = "total_member"
        case imageNumber = "image_number"
        case ownerEmail = "owner_email"
        case activityPlans = "activity_plans"
        case interests
    }
}
