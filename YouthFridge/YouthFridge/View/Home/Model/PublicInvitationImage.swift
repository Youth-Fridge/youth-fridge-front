//
//  PublicInvitationImage.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/24/24.
//

import Foundation

enum PublicInvitationImage: Int, CaseIterable {
    case image0
    case image1
    case image2
    case image3
    case image4
    case image5
    case image6
    case image7
    case image8
    case image9

    var imageName: String {
        switch self {
        case .image0:
            return "invitationImage0"
        case .image1:
            return "invitationImage1"
        case .image2:
            return "invitationImage2"
        case .image3:
            return "invitationImage3"
        case .image4:
            return "invitationImage4"
        case .image5:
            return "invitationImage5"
        case .image6:
            return "invitationImage9" //김장
        case .image7:
            return "invitationImage7" //포트락 파티
        case .image8:
            return "invitationImage8"
        case .image9:
            return "invitationImage9"
        }
    }

    static func from(imageName: String) -> PublicInvitationImage? {
        return PublicInvitationImage.allCases.first { $0.imageName == imageName }
    }
    
    static func from(rawValue: Int) -> PublicInvitationImage? {
        return PublicInvitationImage(rawValue: rawValue)
    }
}

