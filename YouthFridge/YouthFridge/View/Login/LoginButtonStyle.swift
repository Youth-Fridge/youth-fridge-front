//
//  LoginButtonStyle.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI

struct LoginButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let textColor: Color
    let borderColor: Color
    
    init(textColor: Color, borderColor: Color? = nil, backgroundColor: Color? = nil) {
        self.textColor = textColor
        self.borderColor = borderColor ?? textColor
        self.backgroundColor = backgroundColor ?? textColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14))
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(backgroundColor)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: 0.8)
            )
            .padding(.horizontal, 40)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}
