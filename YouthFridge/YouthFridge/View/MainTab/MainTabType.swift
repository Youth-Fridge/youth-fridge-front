//
//  MainTabType.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import Foundation


enum MainTabType: String,CaseIterable {
    case home
    case smallClass
    case news
    case mypage
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .smallClass:
            return "생활밥서"
        case .news:
            return "밥심레터"
        case .mypage:
            return "마이페이지"
        
        }
    }
    
    func imageName(selected: Bool) -> String {
        selected ? "\(rawValue)_fill" : rawValue
    }
}
