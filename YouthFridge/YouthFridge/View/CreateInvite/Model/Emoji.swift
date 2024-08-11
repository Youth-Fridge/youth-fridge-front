//
//  Emoji.swift
//  YouthFridge
//
//  Created by 임수진 on 8/11/24.
//

import Foundation

enum Emoji: Int, CaseIterable {
    case friends
    case hobby
    case healthFood
    case cooking
    case delivery
    case desert
    case basket
    case recipe
    case diet
    case exercise
    case homework
    case reading

    var imageName: String {
        switch self {
        case .friends: return "friends"
        case .hobby: return "hobby"
        case .healthFood: return "healthFood"
        case .cooking: return "cooking"
        case .delivery: return "delivery"
        case .desert: return "desert"
        case .basket: return "basket"
        case .recipe: return "recipe"
        case .diet: return "diet"
        case .exercise: return "exercise"
        case .homework: return "homework"
        case .reading: return "reading"
        }
    }

    static func from(imageName: String) -> Emoji? {
        return Emoji.allCases.first { $0.imageName == imageName }
    }

    static func from(rawValue: Int) -> Emoji? {
        return Emoji(rawValue: rawValue)
    }
}
