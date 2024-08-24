//
//  NavigationManager.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/21/24.
//

import SwiftUI

class NavigationManager: ObservableObject {
    @Published var currentView: NavigationDestination? = nil
    @Published var isLoggedOut = false
    @Published var shouldNavigateToMyActivity: Bool = false
}

enum NavigationDestination {
    case myActivity
    case loginIntro
}
