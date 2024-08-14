//
//  NewsLetterService.swift
//  YouthFridge
//
//  Created by 임수진 on 8/14/24.
//

import Foundation
import Moya

class NewsLetterService {
    static let shared = NewsLetterService()
    static let provider = MoyaProvider<NewsLetterAPI>(plugins: [NetworkLoggerPlugin()])
    
    func getNewsLetter(completion: @escaping (Result<NewsLetterResponse, Error>) -> Void) {
        NewsLetterService.provider.request(.getNewsLetter) { result in
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
                        let data = try JSONDecoder().decode(BaseResponse<NewsLetterResponse>.self, from: response.data)
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
