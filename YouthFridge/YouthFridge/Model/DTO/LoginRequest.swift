//
//  LoginRequest.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/6/24.
//

import Foundation

struct LoginRequest: Codable {
    let email : String
    let type : String
    let username: String
    let token: String
}
