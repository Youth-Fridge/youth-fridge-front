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
