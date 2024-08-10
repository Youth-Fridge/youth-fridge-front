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
}
