//
//  InvitationAPI.swift
//  YouthFridge
//
//  Created by 임수진 on 7/31/24.
//

import Foundation
import Moya

class InvitationAPI {
    static let shared = InvitationAPI()
    static let provider = MoyaProvider<InvitationService>()

    func postPost(data: Data, completion: @escaping (Result<String, Error>) -> Void ) {
        InvitationAPI.provider.request(.postInvitation(data)) { response in
            switch response {
            case .success(let result):
                do {
                    let results = try JSONDecoder().decode(BaseResponse<InvitationResponse>.self, from: result.data)
                    print("result: \(results)")
                } catch let error {
                    print("Decoding error: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
