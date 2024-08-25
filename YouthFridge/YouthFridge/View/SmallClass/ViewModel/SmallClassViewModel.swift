//
//  SmallClassViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/19/24.
//

import Foundation
import Combine

class SmallClassViewModel: ObservableObject {
    @Published var profileImageUrl: Int?

    private var cancellables = Set<AnyCancellable>()
    
    func fetchProfileImage() {
        OnboardingAPI.shared.userInfo { [weak self] result in
            switch result {
            case .success(let userInfoResponse):
                self?.profileImageUrl = userInfoResponse.profileImageNumber
            case .failure(let error):
                print("Failed to fetch user info: \(error.localizedDescription)")
            }
        }
    }

}

