//
//  MyApplicationViewModel.swift
//  YouthFridge
//
//  Created by 임수진 on 7/23/24.
//

import Foundation
import Combine

class MyApplicationViewModel: ObservableObject {
    @Published var applicatedActivities: [ActivityCardViewModel] = []
    @Published var isLoading: Bool = false
    
    func fetchActivities() {
        isLoading = true
        
        InvitationService.shared.getAppliedInvitations { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    self?.applicatedActivities = response.map { ActivityCardViewModel(from: $0) }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
