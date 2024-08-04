//
//  ResearchViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

class ResearchViewModel: ObservableObject {
    @Published var categories: [String] = []
    private let selectedCategoryKey = "selectedCategories"
    
    init() {
        loadCategories()
    }
    
    func loadCategories() {
        self.categories = [
            "⏰ 바쁘다 바빠 간편식이 최고야!",
            "🧑🏻‍🍳 오늘은 내가 요리사, 자취 요리 만렙!",
            "🌱 프로 혼밥러, 1인식이 제일 편해",
            "💪🏻 체중관리를 위해선 무조건 건강식이지",
            "💗 여러 사람과 함께 모여 음식 먹는 게 좋아"
        ]
    }
    
    func saveSelectedCategories(_ selectedIndices: [Int]) {
        let incrementedIndices = selectedIndices.map { $0 + 1 }
        UserDefaults.standard.set(incrementedIndices, forKey: selectedCategoryKey)
        if let savedCategories = UserDefaults.standard.array(forKey: selectedCategoryKey) as? [Int] {
            print("Saved categories: \(savedCategories)")
        } else {
            print("Failed to save categories.")
        }
    }
    
    func loadSelectedCategories() -> [Int] {
        guard let savedCategories = UserDefaults.standard.array(forKey: selectedCategoryKey) as? [Int] else {
            return []
        }
        return savedCategories.map { $0 - 1 }
    }
}


