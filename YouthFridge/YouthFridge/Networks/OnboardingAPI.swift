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
        let target = OnboardingService.nicknameCheck(nickname)
        if let request = try? OnboardingAPI.provider.endpoint(target).urlRequest() {
            print("Request URL: \(request.url?.absoluteString ?? "Invalid URL")")
        }
        
        OnboardingAPI.provider.request(.nicknameCheck(nickname)) { result in
            switch result {
            case .success(let response):
                if let responseString = String(data: response.data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                } else {
                    print("Unable to convert response data to string")
                }

                switch response.statusCode {
                case 200:
                    do {
                        let data = try JSONDecoder().decode(BaseResponse<String>.self, from: response.data)
                        let isAvailable = data.result == "사용가능한 닉네임입니다."
                        completion(.success(isAvailable))
                    } catch {
                        completion(.failure(error))
                    }
                case 400:
                    let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Bad Request"])
                    completion(.failure(error))
                case 403:
                    let error = NSError(domain: "", code: 403, userInfo: [NSLocalizedDescriptionKey: "Forbidden"])
                    completion(.failure(error))
                default:
                    let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unhandled status code: \(response.statusCode)"])
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
                        if let responseString = String(data: response.data, encoding: .utf8) {
                            print("Response Data: \(responseString)")
                        } else {
                            print("Unable to convert response data to string")
                        }
                        
                        if response.statusCode == 200 {
                            print("SignUp successful")
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
