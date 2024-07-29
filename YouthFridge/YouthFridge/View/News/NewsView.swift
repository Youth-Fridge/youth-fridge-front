//
//  NewsView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI
import WebKit

struct NewsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                BlogWebView(urlToLoad: "https://blog.naver.com/suzinlim")
                    .edgesIgnoringSafeArea(.bottom)
                    .navigationTitle("밥심레터")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

#Preview {
    NewsView()
}
