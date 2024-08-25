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
    @Published var isLoading: Bool = false

    func fetchActivities() {
        isLoading = true
        
        InvitationService.shared.getMyInvitations { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    self?.invitationActivities = response.map { ActivityCardViewModel(from: $0) }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
