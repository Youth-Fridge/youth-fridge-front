//
//  TabSelectionViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/24/24.
//

import SwiftUI

class TabSelectionViewModel: ObservableObject {
    @Published var selectedTab: MainTabType = .home
}
