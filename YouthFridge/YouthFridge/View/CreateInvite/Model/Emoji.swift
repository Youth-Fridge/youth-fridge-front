//
//  Emoji.swift
//  YouthFridge
//
//  Created by 임수진 on 8/11/24.
//

import Foundation

enum Emoji: Int, CaseIterable {
    case basket = 1
    case cooking
    case delivery
    case desert
    case diet
    case friends
    case healthFood
    case hobby
    case reading
    case recipe
    case homework
    case exercise

    var imageName: String {
        switch self {
        case .basket: return "basket"
        case .cooking: return "cooking"
        case .delivery: return "delivery"
        case .desert: return "desert"
        case .diet: return "diet"
        case .friends: return "friends"
        case .healthFood: return "healthFood"
        case .hobby: return "hobby"
        case .reading: return "reading"
        case .recipe: return "recipe"
        case .homework: return "homework"
        case .exercise: return "exercise"
        }
    }

    static func from(imageName: String) -> Emoji? {
        return Emoji.allCases.first { $0.imageName == imageName }
    }

    static func from(rawValue: Int) -> Emoji? {
        return Emoji(rawValue: rawValue)
    }
}
