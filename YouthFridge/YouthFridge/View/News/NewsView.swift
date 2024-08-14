//
//  NewsView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI
import WebKit

struct NewsView: View {
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    BlogWebView(urlToLoad: "https://m.blog.naver.com/hyangyuloum", scrollTo: CGPoint(x: 0, y: 750), isLoading: $isLoading)
                        .edgesIgnoringSafeArea(.bottom)
                        .navigationTitle("밥심레터")
                        .navigationBarTitleDisplayMode(.inline)
                }

                if isLoading {
                    GeometryReader { geometry in
                        VStack {
                            Text("로딩 중...")
                                .font(.headline)
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .background(Color.white.opacity(1))
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    NewsView()
}
