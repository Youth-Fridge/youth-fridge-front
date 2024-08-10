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
//    static let provider = MoyaProvider<InvitationAPI>()
    static let provider = MoyaProvider<InvitationAPI>(plugins: [NetworkLoggerPlugin()])
    private init() {}
    
    func createInvitation(data: Data, completion: @escaping (Result<BaseResponse<String>, Error>) -> Void) {
        InvitationService.provider.request(.createInvitation(data)) { result in
            switch result {
            case .success(let response):
                self.handleResponse(response, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func handleResponse(_ response: Response, completion: @escaping (Result<BaseResponse<String>, Error>) -> Void) {
        guard (200...299).contains(response.statusCode) else {
            let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "Error: \(response.statusCode)"])
            return completion(.failure(error))
        }
        
        do {
            let baseResponse = try JSONDecoder().decode(BaseResponse<String>.self, from: response.data)
            if baseResponse.isSuccess {
                completion(.success(baseResponse))
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: baseResponse.message])
                completion(.failure(error))
            }
        } catch {
            completion(.failure(error))
        }
    }
}
