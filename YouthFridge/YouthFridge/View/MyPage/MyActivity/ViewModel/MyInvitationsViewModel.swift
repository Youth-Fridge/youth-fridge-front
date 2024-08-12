//
//  MyInvitationsViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import Foundation
import Combine

class MyInvitationsViewModel: ObservableObject {
    @Published var invitationActivities: [ActivityCardViewModel] = []
    
    init() {
        fetchActivities()
    }
    
    func fetchActivities() {
        InvitationService.shared.getMyInvitations { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.invitationActivities = response.map { ActivityCardViewModel(from: $0) }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
