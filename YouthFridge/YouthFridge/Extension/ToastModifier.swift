//
//  ToastModifier.swift
//  YouthFridge
//
//  Created by 임수진 on 8/29/24.
//

import Foundation
import SwiftUI

struct ToastModifier: ViewModifier {
    var isShowing: Bool
    var message: String

    func body(content: Content) -> some View {
        ZStack {
            content
            if isShowing {
                VStack {
                    Spacer()
                    Text(message)
                        .font(.system(size: 14, weight: .semibold))
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.bottom, 50) // Adjust to fit above the keyboard
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3))
                }
                .padding()
            }
        }
    }
}

extension View {
    func toast(isShowing: Bool, message: String) -> some View {
        self.modifier(ToastModifier(isShowing: isShowing, message: message))
    }
}
