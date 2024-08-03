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
    
    func signUp(_ request: OnboardingRequest, completion: @escaping (Result<Void, Error>) -> Void) {
            do {
                let data = try JSONEncoder().encode(request)
                OnboardingAPI.provider.request(.signUp(data)) { result in
                    switch result {
                    case .success(let response):
                        if response.statusCode == 200 {
                            completion(.success(()))
                        } else {
                            let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "SignUp failed with status code: \(response.statusCode)"])
                            completion(.failure(error))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
}

struct NicknameCheckResponse: Codable {
    let isAvailable: Bool
}

