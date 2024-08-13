//
//  MyPageViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import Foundation
import SwiftUI

class MyPageViewModel: ObservableObject {
    @Published var myUser: User?
    private var container: DIContainer
    let bigProfileImages = ["bigBrocoli", "bigPea", "bigCorn", "bigTomato", "bigBranch", "bigPumpkin"]
    init(container: DIContainer) {
        self.container = container
        fetchUserData()
    }
    
    private func fetchUserData() {
        let selectedImageIndex = getSelectedImageIndex()
        let nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
        let profileImage = (selectedImageIndex > 0 && selectedImageIndex <= bigProfileImages.count)
            ? bigProfileImages[selectedImageIndex - 1]
            : "Ellipse" 
        
        myUser = User(name: nickname, profilePicture: profileImage)
    }
    
    private func getSelectedImageIndex() -> Int {
        return UserDefaults.standard.integer(forKey: "profileImageNumber")
    }
}

