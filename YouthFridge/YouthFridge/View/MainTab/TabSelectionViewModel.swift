//
//  TabSelectionViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/24/24.
//

import SwiftUI

class TabSelectionViewModel: ObservableObject {
    @Published var selectedTab: MainTabType = .home
    @Published var shouldNavigateToMyActivity: Bool = false
    @Published var selectedSubTab: Int = 0
    
    var mypageViewModel: MyPageViewModel? {
        if selectedTab == .mypage {
            let viewModel = MyPageViewModel(container: DIContainer(services: Services()))
            if shouldNavigateToMyActivity {
                DispatchQueue.main.async {
                    viewModel.navigateToMyActivityView()
                }
            }
            return viewModel
        }
        return nil
    }
}

