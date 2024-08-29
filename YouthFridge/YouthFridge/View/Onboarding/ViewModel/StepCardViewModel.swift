//
//  StepCardViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/29/24.
//

import SwiftUI

struct StepCardViewModel: Identifiable {
    let id = UUID()
    let number: String
    let title: String
    let subtitle: String
    let subtitle2: String
    let backgroundColor: Color
}
