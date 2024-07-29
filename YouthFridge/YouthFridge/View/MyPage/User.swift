//
//  User.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import Foundation

struct User: Identifiable {
    let id = UUID()
    var name: String
    var profilePicture: String
}
