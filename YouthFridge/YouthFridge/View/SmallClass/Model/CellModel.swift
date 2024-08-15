//
//  CellModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/20/24.
//

import Foundation

struct CellModel: Identifiable, Equatable {
    let id : Int
    let image: String
    let title: String
    let tag: [String]
    let ing: String
    let numberOfPeople: String
}
