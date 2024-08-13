//
//  ShadowNavigationBar.swift
//  YouthFridge
//
//  Created by 임수진 on 7/21/24.
//

import SwiftUI

struct ShadowNavigationBar: View {
    var body: some View {
        VStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.1), Color.clear]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 17)
            Spacer()
        }
    }
}

#Preview {
    ShadowNavigationBar()
}
