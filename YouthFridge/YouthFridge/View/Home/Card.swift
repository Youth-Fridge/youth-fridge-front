//
//  Card.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import Foundation
import SwiftUI

struct Card: Identifiable {
    let id: Int
    let name: String
    let title: String
    let location: String
    let tags: [String]
    let emojiNumber: Int
    let profileImageNumber: Int
    let startTime: String
    let endTime: String
    let launchDate: String

    private func combinedDateTime() -> Date? {
        let combinedString = "\(launchDate) \(startTime)"
        return DateFormatter.fullDateTimeFormatter.date(from: combinedString)
    }
    
    var ing: String {
        guard let endDate = combinedDateTime() else {
            return "모집중"
        }
        return Date() > endDate ? "모집완료" : "모집중"
    }
    
    var formattedDateAndTime: String {
        guard let dateTime = combinedDateTime() else {
            return "Unknown Date"
        }
        return "\(DateFormatter.displayDateFormatter.string(from: dateTime)) \(DateFormatter.displayTimeFormatter.string(from: dateTime))"
    }
    var emojiImageName: String {
        return emojiImages.indices.contains(emojiNumber) ? emojiImages[emojiNumber] : ""
    }
    
    var profileImageName: String {
        return profileImages.indices.contains(profileImageNumber) ? profileImages[profileImageNumber] : ""
    }
    var backgroundColor: Color {
        switch emojiNumber {
        case 0: return Color.imojiBlack
        case 1: return Color.imojiBrown
        case 2: return Color.imojiPink
        case 3: return Color.imojiBrown2
        case 4: return Color.imojiPurple
        case 5: return Color.imojiGreen2
        case 6: return Color.imojiGreen3
        case 7: return Color.imojiBook
        case 8: return Color.imojiOrange
        case 9: return Color.imojiGreen
        case 10: return Color.imojiBrown3
        case 11: return Color.imojiBrown4
        default: return Color.gray
        }
    }
    private let profileImages = ["broccoli", "pea", "corn", "tomato", "branch", "pumpkin"]
    private let emojiImages = ["bigFriends","bigHobby","bigHealthFood","bigCooking","bigDelivery","bigDesert","bigBasket","bigRecipe","bigDiet","bigExercise","bigHomework","bigReading"]
}
