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
    @State private var reload = false
    @Binding var urlToLoad: String
    private let specificURL = "https://m.blog.naver.com/hyangyuloum"
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    BlogWebView(
                        urlToLoad: urlToLoad,
                        scrollTo: urlToLoad == specificURL ? CGPoint(x: 0, y: 780) : CGPoint(x: 0, y: 80),
                        isLoading: $isLoading,
                        reload: $reload
                    )
                    .edgesIgnoringSafeArea(.bottom)
                    .navigationTitle("밥심레터")
                    .navigationBarTitleDisplayMode(.inline)
                    .onAppear {
                        reload = true
                    }
                    Spacer(minLength: 5)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        let profileNumber = UserDefaults.standard.integer(forKey: "profileImageNumber")
                        if let profile = ProfileImage.from(rawValue: profileNumber) {
                            let profileImage = profile.imageName
                            
                            Image(profileImage)
                                .resizable()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                        }
                    }
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
