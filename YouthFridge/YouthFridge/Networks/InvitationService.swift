//
//  InvitationService.swift
//  YouthFridge
//
//  Created by 임수진 on 7/31/24.
//

import SwiftUI
import Moya
import Combine

class InvitationService {
    static let shared = InvitationService()
    static let provider = MoyaProvider<InvitationAPI>()
    // 로그 확인용 (plugins: [NetworkLoggerPlugin()])
    private init() {}
    
    // MARK: - Network Error
    enum NetworkError: Error {
        case badRequest
        case forbidden
        case unhandledStatusCode(Int)
        case decodingError(Error)
        case customError(String)
        case unknownError(String)
        
        var localizedDescription: String {
            switch self {
            case .badRequest:
                return "Bad Request"
            case .forbidden:
                return "Forbidden"
            case .unhandledStatusCode(let statusCode):
                return "Unhandled status code: \(statusCode)"
            case .decodingError(let error):
                return "Decoding error: \(error.localizedDescription)"
            case .customError(let message):
                return message
            case .unknownError(let message):
                return message
            }
        }
    }
    
    // MARK: - Network Request Handler
    private func handleResponse<T: Codable>(response: Response, completion: @escaping (Result<T, NetworkError>) -> Void) {
        switch response.statusCode {
        case 200:
            do {
                let baseResponse = try JSONDecoder().decode(BaseResponse<T>.self, from: response.data)
                if baseResponse.isSuccess {
                    if let result = baseResponse.result {
                        completion(.success(result))
                    } else {
                        completion(.failure(.customError(baseResponse.message)))
                    }
                } else {
                    completion(.failure(.customError(baseResponse.message)))
                }
            } catch {
                completion(.failure(.decodingError(error)))
            }
        case 400:
            completion(.failure(.badRequest))
        case 403:
            completion(.failure(.forbidden))
        default:
            completion(.failure(.unhandledStatusCode(response.statusCode)))
        }
    }
    
    // MARK: - API Functions
    func createInvitation(data: Data, completion: @escaping (Result<String, NetworkError>) -> Void) {
        InvitationService.provider.request(.createInvitation(data)) { result in
            switch result {
            case .success(let response):
                self.handleResponse(response: response, completion: completion)
            case .failure(let error):
                completion(.failure(.customError(error.localizedDescription)))
            }
        }
    }
    
    func getMyInvitations(completion: @escaping (Result<[MyActivitiesResponse], NetworkError>) -> Void) {
        InvitationService.provider.request(.getMyInvitations(page: 0, size: 10)) { result in
            switch result {
            case .success(let response):
                self.handleResponse(response: response, completion: completion)
            case .failure(let error):
                completion(.failure(.customError(error.localizedDescription)))
            }
        }
    }
    
    func getMyDetailInvitation(invitationId: Int, completion: @escaping (Result<MyInvitationDetailResponse, NetworkError>) -> Void) {
        InvitationService.provider.request(.getMyDetailInvitation(invitationId: invitationId)) { result in
            switch result {
            case .success(let response):
                self.handleResponse(response: response, completion: completion)
            case .failure(let error):
                completion(.failure(.customError(error.localizedDescription)))
            }
        }
    }
    
    func getAppliedInvitations(completion: @escaping (Result<[MyActivitiesResponse], NetworkError>) -> Void) {
        InvitationService.provider.request(.getAppliedInvitations(page: 0, size: 10)) { result in
            switch result {
            case .success(let response):
                self.handleResponse(response: response, completion: completion)
            case .failure(let error):
                completion(.failure(.customError(error.localizedDescription)))
            }
        }
    }
    
    func getInvitationList(page: Int, size: Int, completion: @escaping (Result<[InvitationListResponse], NetworkError>) -> Void) {
        InvitationService.provider.request(.smallClassList(page: page, size: size)) { result in
            switch result {
            case .success(let response):
                self.handleResponse(response: response, completion: completion)
            case .failure(let error):
                completion(.failure(.customError(error.localizedDescription)))
            }
        }
    }
    
    func getMyApplicationDetail(invitationId: Int, completion: @escaping (Result<MyAppliedInvitationDetailResponse, NetworkError>) -> Void) {
        InvitationService.provider.request(.getAppliedDetailInvitation(invitationId: invitationId)) { result in
            switch result {
            case .success(let response):
                self.handleResponse(response: response, completion: completion)
            case .failure(let error):
                completion(.failure(.customError(error.localizedDescription)))
            }
        }
    }
    

    func getInvitationDetail(invitationId: Int, completion: @escaping (Result<InvitationDetailResponse, NetworkError>) -> Void) {
        InvitationService.provider.request(.getInvitation(invitationId: invitationId)) { result in
            switch result {
            case .success(let response):
                self.handleResponse(response: response, completion: completion)
            case .failure(let error):
                completion(.failure(.customError(error.localizedDescription)))
            }
        }
    }

    func getImminentInvitation(completion: @escaping (Result<ImminentInvitationResponse?, NetworkError>) -> Void) {
        InvitationService.provider.request(.getImminentInvitation) { result in

            switch result {
            case .success(let response):
                self.handleResponse(response: response, completion: completion)
            case .failure(let error):
                completion(.failure(.customError(error.localizedDescription)))
            }
        }
    }

    
    func applyInvitation(invitationId: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        InvitationService.provider.request(.applyInvitation(invitationId: invitationId)) { result in
            switch result {
            case .success(let response):
                do {
                    // 응답 데이터 파싱
                    let responseData = try response.mapJSON() as? [String: Any]
                    
                    let isSuccess = responseData?["isSuccess"] as? Bool ?? false
                    let code = responseData?["code"] as? String
                    let message = responseData?["message"] as? String ?? "Unknown error occurred."
                    
                    if isSuccess {
                        completion(.success("소모임 신청이 완료되었습니다."))
                    } else {
                        let localizedMessage: String
                        switch code {
                        case "INVITATION4002":
                            localizedMessage = "이미 소모임을 신청한 회원입니다."
                        default:
                            localizedMessage = message
                        }
                        completion(.failure(.customError("이미 신청한 소모임입니다.")))
                    }
                } catch {
                    completion(.failure(.decodingError(error)))
                }
                
            case .failure(let error):
                let networkError: NetworkError
                if let moyaError = error as? MoyaError {
                    switch moyaError.response?.statusCode {
                    case 400:
                        networkError = .badRequest
                    case 403:
                        networkError = .forbidden
                    default:
                        networkError = .unhandledStatusCode(moyaError.response?.statusCode ?? -1)
                    }
                } else {
                    networkError = .unknownError(error.localizedDescription)
                }
                completion(.failure(networkError))
            }
        }
    }
    
    func cancelInvitation(invitationId: Int) -> AnyPublisher<String, NetworkError> {
        let target = InvitationAPI.cancelInvitation(invitationId: invitationId)
        
        return Future<String, NetworkError> { promise in
            InvitationService.provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let baseResponse = try JSONDecoder().decode(BaseResponse<String>.self, from: response.data)
                        if baseResponse.isSuccess, let message = baseResponse.result {
                            promise(.success(message))
                        } else {
                            promise(.failure(.customError(baseResponse.message)))
                        }
                    } catch {
                        promise(.failure(.decodingError(error)))
                    }
                case .failure(let error):
                    promise(.failure(.customError(error.localizedDescription)))
                }
            }
        }
        .eraseToAnyPublisher() // AnyPublisher 반환
    }

}
