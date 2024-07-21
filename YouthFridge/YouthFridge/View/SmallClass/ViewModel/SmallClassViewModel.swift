//
//  SmallClassViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/20/24.
//

import SwiftUI

class SmallClassViewModel: ObservableObject {
    @Published var cells: [CellModel] = [
        CellModel(image: "image1", title: "Title 1", content: "Content 1", tag: "Tag 1"),
        CellModel(image: "image2", title: "Title 2", content: "Content 2", tag: "Tag 2"),
        CellModel(image: "image3", title: "Title 3", content: "Content 3", tag: "Tag 3"),
        CellModel(image: "image4", title: "Title 4", content: "Content 4", tag: "Tag 4"),
        CellModel(image: "image5", title: "Title 5", content: "Content 5", tag: "Tag 5")
    ]
}
