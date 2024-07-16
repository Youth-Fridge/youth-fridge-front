//
//  ActivityCardViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import Foundation

class ActivityCardViewModel: ObservableObject, Identifiable {
    let id = UUID()
    @Published var title: String
    @Published var date: String
    @Published var location: String
    @Published var daysLeft: Int
    @Published var imageName: String
    @Published var isPast: Bool
    
    init(title: String, date: String, location: String, daysLeft: Int, imageName: String, isPast: Bool = false) {
        self.title = title
        self.date = date
        self.location = location
        self.daysLeft = daysLeft
        self.imageName = imageName
        self.isPast = isPast
    }
}
