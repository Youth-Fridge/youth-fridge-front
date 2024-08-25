//
//  YouthFridge++Bundle.swift
//  YouthFridge
//
//  Created by 임수진 on 8/25/24.
//

import Foundation

extension Bundle {
    var KAKAO_API_KEY: String {
        guard let file = self.path(forResource: "Secret", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        guard let key = resource["KAKAO_API_KEY"] as? String else {
            fatalError("Secret.plist의 KAKAO_API_KEY에 유효한 값 설정을 해주세요")
        }
        return key
    }
}
