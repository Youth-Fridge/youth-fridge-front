//
//  HomeAPI.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/6/24.
//

import Foundation
import Moya

class HomeAPI {
    static let shared = HomeAPI()
    static let provider = MoyaProvider<InvitationAPI>()

    // MARK: - Top Five Invitations
    func fetchTopFiveInvitations(completion: @escaping (Result<[InvitationTopFiveResponse], Error>) -> Void) {
        InvitationService.provider.request(.getInvitationsTop5) { result in
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
                        let data = try JSONDecoder().decode(BaseResponse<[InvitationTopFiveResponse]>.self, from: response.data)
                        if let invitations = data.result {
                            completion(.success(invitations))
                        } else {
                            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No invitations found"])
                            completion(.failure(error))
                        }
                    } catch {
                        completion(.failure(error))
                    }
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
