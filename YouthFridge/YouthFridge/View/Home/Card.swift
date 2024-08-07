//
//  Card.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import Foundation

struct Card: Identifiable {
    let id = UUID()
    let name : String
    let title: String
    let date: String
    let location: String
    let tags: [String]
    let ing: String
    let imageName: String
}
