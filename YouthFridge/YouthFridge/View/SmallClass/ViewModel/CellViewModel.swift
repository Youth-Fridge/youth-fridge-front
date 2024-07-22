//
//  CellViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/20/24.
//

import SwiftUI

class CellViewModel: ObservableObject {
    @Published var cells: [CellModel] = [
        CellModel(image: "invitationImage", title: "천안 밥집투어", tag: "배달",ing: "모집 중",numberOfPeople: "3/7"),
        CellModel(image: "invitationImage2", title: "Title 1", tag: "취미",ing: "모집 중",numberOfPeople: "3/7"),
        CellModel(image: "invitationImage3", title: "Title 1", tag: "다이어트",ing: "모집 중",numberOfPeople: "3/7"),
        CellModel(image: "invitationImage4", title: "Title 1", tag: "가벼운",ing: "모집 중",numberOfPeople: "3/7"),
        CellModel(image: "invitationImage", title: "Title 1", tag: "다이어트",ing: "모집 중",numberOfPeople: "3/7")
    ]
}
