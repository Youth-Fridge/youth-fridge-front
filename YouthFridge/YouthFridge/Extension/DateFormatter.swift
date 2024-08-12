//
//  DateFormatter.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/11/24.
//

import Foundation

extension DateFormatter {
    
    static let fullDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    static let launchDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    static let displayTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h시"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    static func date(from string: String, formatter: DateFormatter) -> Date? {
        return formatter.date(from: string)
    }
}


