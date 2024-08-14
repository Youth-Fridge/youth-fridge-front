//
//  NewsLetterAPI.swift
//  YouthFridge
//
//  Created by 임수진 on 8/14/24.
//

import Foundation
import Moya

enum NewsLetterAPI {
    case getNewsLetter
}

extension NewsLetterAPI: TargetType {

    var baseURL: URL {
        return URL(string: GeneralAPI.baseURL)!
    }

    var path: String {
        switch self {
        case .getNewsLetter:
            return "/api/news"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getNewsLetter:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .getNewsLetter:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        var headers: [String: String] = ["Content-Type": "application/json"]
        
        if let accessToken = getAccessToken() {
            headers["Authorization"] = accessToken
        }
        
        return headers
    }
    
    private func getAccessToken() -> String? {
        return KeychainHandler.shared.accessToken
    }
}
