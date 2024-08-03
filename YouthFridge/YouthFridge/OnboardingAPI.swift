//
//  OnboardingAPI.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/2/24.
//

import Foundation
import Moya

class OnboardingAPI {
    static let shared = OnboardingAPI()
    static let provider = MoyaProvider<OnboardingService>()
    
    func checkNickname(_ nickname: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        OnboardingAPI.provider.request(.nicknameCheck(nickname)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(NicknameCheckResponse.self, from: response.data)
                    completion(.success(data.isAvailable))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct NicknameCheckResponse: Codable {
    let isAvailable: Bool
}

