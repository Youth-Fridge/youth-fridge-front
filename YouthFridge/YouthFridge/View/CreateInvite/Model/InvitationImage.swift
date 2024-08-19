//
//  InvitationImage.swift
//  YouthFridge
//
//  Created by 임수진 on 8/11/24.
//

import Foundation

enum InvitationImage: Int, CaseIterable {
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
            return "publicImage0" //김장
        case .image7:
            return "publicImage2" //포트락 파티
        case .image8:
            return "publicImage1"
        case .image9:
            return "publicImage0"
        }
    }

    static func from(imageName: String) -> InvitationImage? {
        return InvitationImage.allCases.first { $0.imageName == imageName }
    }
    
    static func from(rawValue: Int) -> InvitationImage? {
        return InvitationImage(rawValue: rawValue)
    }
}
