//
//  CustomProgressViewStyle.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/17/24.
//

import Foundation
import SwiftUI

struct CustomProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .tint(.sub2Color)
    }
}
