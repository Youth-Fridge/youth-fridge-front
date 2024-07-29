//
//  BlogWebView.swift
//  YouthFridge
//
//  Created by 임수진 on 7/29/24.
//

import SwiftUI
import WebKit

struct BlogWebView: UIViewRepresentable {
    var urlToLoad: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: urlToLoad) {
            webView.load(URLRequest(url: url))
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

#Preview {
    BlogWebView(urlToLoad: "https://blog.naver.com/suzinlim")
}
