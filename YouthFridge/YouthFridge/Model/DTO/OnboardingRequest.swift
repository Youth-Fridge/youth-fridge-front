//
//  OnboardingRequest.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/1/24.
//

import Foundation

struct OnboardingRequest: Codable {
    let type: String
    let email: String
    let nickname: String
    let introduce: String
    let role: String
    let profileImageNumber: Int
    let town: String
}
