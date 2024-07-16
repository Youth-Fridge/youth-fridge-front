//
//  ResearchViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

// ViewModel 정의
class ResearchViewModel: ObservableObject {
    @Published var categories: [String]
    
    init() {
        self.categories = [
            "⏰ 바쁘다 바빠 간편식이 최고야!",
            "🧑🏻‍🍳 오늘은 내가 요리사, 자취 요리 만렙!",
            "🌱 프로 혼밥러, 1인식이 제일 편해",
            "💪🏻 체중관리를 위해선 무조건 건강식이지",
            "💗 여러 사람과 함께 모여 음식 먹는 게 좋아"
        ]
    }
}
