//
//  MyPageViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import Foundation

class MyPageViewModel: ObservableObject {
    @Published var myUser: User?
    private var container: DIContainer
    init(container: DIContainer) {
        self.container = container
        fetchUserData()
    }
    
    private func fetchUserData() {
        myUser = User(name: "장금이", profilePicture: "Ellipse20")
    }
}
