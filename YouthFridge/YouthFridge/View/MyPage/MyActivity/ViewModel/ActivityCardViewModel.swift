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
    @Published var participants: [User]
    
    var participantsList: [User] = [
        User(name: "임수진", profilePicture: "Ellipse"),
        User(name: "김민솔", profilePicture: "Ellipse"),
        User(name: "최강", profilePicture: "Ellipse"),
        User(name: "임수진", profilePicture: "Ellipse"),
        User(name: "김민솔", profilePicture: "Ellipse"),
        User(name: "최강", profilePicture: "Ellipse")
    ]
    
    init(title: String, date: String, location: String, daysLeft: Int, imageName: String, isPast: Bool = false, participants: [User] = []) {
        self.title = title
        self.date = date
        self.location = location
        self.daysLeft = daysLeft
        self.imageName = imageName
        self.isPast = isPast
        self.participants = participantsList
    }
}
