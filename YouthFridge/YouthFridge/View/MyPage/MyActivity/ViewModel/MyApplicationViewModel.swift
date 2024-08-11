//
//  MyApplicationViewModel.swift
//  YouthFridge
//
//  Created by 임수진 on 7/23/24.
//

import Foundation
import SwiftUI

class MyApplicationViewModel: ObservableObject {
    @Published var applicatedActivities: [ActivityCardViewModel] = []
//    var participantsList: [User] = [
//        User(name: "임수진", profilePicture: "Ellipse"),
//        User(name: "김민솔", profilePicture: "Ellipse"),
//        User(name: "최강", profilePicture: "Ellipse"),
//        User(name: "임수진", profilePicture: "Ellipse"),
//        User(name: "김민솔", profilePicture: "Ellipse"),
//        User(name: "최강", profilePicture: "Ellipse")
//    ]
    
    init() {
        fetchActivities()
    }
    
    func fetchActivities() {
        InvitationService.shared.getAppliedInvitations { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.applicatedActivities = response.map { ActivityCardViewModel(from: $0) }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
