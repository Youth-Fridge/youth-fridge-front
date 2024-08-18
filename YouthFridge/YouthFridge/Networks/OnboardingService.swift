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
    case quitMember
    case userInfo //사용자 정보
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
        case .quitMember:
            return .requestPlain
        case .userInfo:
            return .requestPlain
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
        case .quitMember:
            return "/api/delete-account"
        case .userInfo:
            return "/api/member"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .signUp:
            return .post
        case .nicknameCheck:
            return .get
        case .quitMember:
            return .delete
        case .userInfo:
            return .get
        }
    }
    
    var headers: [String : String]? {
        var headers: [String: String] = ["Content-Type": "application/json"]
        
        switch self {
        case .quitMember, .userInfo:
            if let accessToken = getAccessToken() {
                headers["Authorization"] = accessToken
            }
        default:
            break
        }
        
        return headers
    }
    
    private func getAccessToken() -> String? {
        return KeychainHandler.shared.accessToken
    }
}
