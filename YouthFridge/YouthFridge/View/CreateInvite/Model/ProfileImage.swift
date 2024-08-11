//
//  ProfileImage.swift
//  YouthFridge
//
//  Created by 임수진 on 8/11/24.
//

import Foundation

enum ProfileImage: Int, CaseIterable {
    case broccoli
    case pea
    case corn
    case tomato
    case branch
    case pumpkin

    var imageName: String {
        switch self {
        case .broccoli: return "broccoli"
        case .pea: return "pea"
        case .corn: return "corn"
        case .tomato: return "tomato"
        case .branch: return "branch"
        case .pumpkin: return "pumpkin"
        }
    }

    static func from(imageName: String) -> ProfileImage? {
        return ProfileImage.allCases.first { $0.imageName == imageName }
    }

    static func from(rawValue: Int) -> ProfileImage? {
        return ProfileImage(rawValue: rawValue)
    }
}
