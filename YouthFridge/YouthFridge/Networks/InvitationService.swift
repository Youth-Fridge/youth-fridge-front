//
//  InvitationService.swift
//  YouthFridge
//
//  Created by 임수진 on 7/31/24.
//

import SwiftUI
import Moya

class InvitationService {
    static let shared = InvitationService()
    static let provider = MoyaProvider<InvitationAPI>()
    private init() {}
    
    func createInvitation(data: Data, completion: @escaping (Result<String, Error>) -> Void) {
        InvitationService.provider.request(.createInvitation(data)) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    do {
                        let baseResponse = try JSONDecoder().decode(BaseResponse<String>.self, from: response.data)
                        if baseResponse.isSuccess {
                            completion(.success(baseResponse.result ?? ""))
                        } else {
                            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: baseResponse.message])
                            completion(.failure(error))
                        }
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
    
    func getMyInvitations(completion: @escaping (Result<[MyActivitiesResponse], Error>) -> Void) {
        InvitationService.provider.request(.getMyInvitations(page: 0, size: 10)) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    do {
                        let baseResponse = try JSONDecoder().decode(BaseResponse<[MyActivitiesResponse]>.self, from: response.data)
                        if baseResponse.isSuccess {
                            guard let result = baseResponse.result else { return }
                            completion(.success(result))
                        } else {
                            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: baseResponse.message])
                            completion(.failure(error))
                        }
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
    
    func getMyDetailInvitation(invitationId: Int, completion: @escaping (Result<MyInvitationDetailResponse, Error>) -> Void) {
        InvitationService.provider.request(.getMyDetailInvitation(invitationId: invitationId)) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    do {
                        let baseResponse = try JSONDecoder().decode(BaseResponse<MyInvitationDetailResponse>.self, from: response.data)
                        if baseResponse.isSuccess {
                            guard let result = baseResponse.result else { return }
                            completion(.success(result))
                        } else {
                            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: baseResponse.message])
                            completion(.failure(error))
                        }
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

    func getAppliedInvitations(completion: @escaping (Result<[MyActivitiesResponse], Error>) -> Void) {
        InvitationService.provider.request(.getAppliedInvitations(page: 0, size: 10)) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    do {
                        let baseResponse = try JSONDecoder().decode(BaseResponse<[MyActivitiesResponse]>.self, from: response.data)
                        if baseResponse.isSuccess {
                            guard let result = baseResponse.result else { return }
                            completion(.success(result))
                        } else {
                            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: baseResponse.message])
                            completion(.failure(error))
                        }
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
}
