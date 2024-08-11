//
//  JSONUtilities.swift
//  YouthFridge
//
//  Created by 임수진 on 8/9/24.
//

import Foundation

extension JSONEncoder {
    static func withDateFormatter(dateFormatter: DateFormatter) -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }
}

extension JSONDecoder {
    static func withDateFormatter(dateFormatter: DateFormatter) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
}

extension Date {
    func toFormattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일"
        return dateFormatter.string(from: self)
    }
}
