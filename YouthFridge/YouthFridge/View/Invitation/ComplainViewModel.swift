//
//  ComplainViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/30/24.
//

import Foundation
import SwiftUI

class ComplainViewModel: ObservableObject {
    @Published var categories: [String] = []
    private let selectedCategoryKey = "selectedComplain"
    
    init() {
        loadCategories()
    }
    
    // Initialize the categories
    func loadCategories() {
        self.categories = [
            "적절하지 않은 주제의 모임입니다.",
            "욕설/혐오/비속어가 포함되어 있습니다.",
            "모임의 세부 활동에 문제가 있습니다.",
            "모임의 장소에 문제가 있습니다.",
            "모임의 오픈채팅방에 문제가 있습니다.",
            "기타"
        ]
    }
    
    func saveSelectedCategories(_ selectedIndices: [Int]) {
        let incrementedIndices = selectedIndices.map { $0 + 1 }
        UserDefaults.standard.set(incrementedIndices, forKey: selectedCategoryKey)
        UserDefaults.standard.synchronize()
        
        if let savedCategories = UserDefaults.standard.array(forKey: selectedCategoryKey) as? [Int] {
            print("Saved categories: \(savedCategories)")
        } else {
            print("Failed to save categories.")
        }
    }
    func loadSelectedCategories() -> [Int] {
        guard let savedCategories = UserDefaults.standard.array(forKey: selectedCategoryKey) as? [Int] else {
            return [1]
        }
        return savedCategories.map { $0 - 1 }
    }
}
