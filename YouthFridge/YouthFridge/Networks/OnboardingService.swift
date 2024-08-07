//
//  OnboardingService.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/1/24.
//

import Foundation
import Moya
import SwiftKeychainWrapper

enum OnboardingService {
    case signUp(Data)
    case login(Data)
    case nicknameCheck(String)
}

extension OnboardingService: TargetType {
    var task: Moya.Task {
        switch self {
        case .signUp(let data):
            return .requestData(data)
        case .login(let data):
            return .requestData(data)
        case .nicknameCheck(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.queryString)
        }
    
    }
    
    
    var baseURL: URL {
        return URL(string: GeneralAPI.baseURL)!
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/api/signup"
        case .login:
            return "/api/login"
        case .nicknameCheck:
            return "/api/member/nickname"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .signUp:
            return .post
        case .nicknameCheck:
            return .get
        }
    }
    
    var headers: [String : String]? {
        var headers = ["Content-Type": "application/json"]
        return headers
    }
}
