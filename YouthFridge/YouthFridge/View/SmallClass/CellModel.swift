//
//  CellModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/20/24.
//

import Foundation

struct CellModel: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let content: String
    let tag: String
}
