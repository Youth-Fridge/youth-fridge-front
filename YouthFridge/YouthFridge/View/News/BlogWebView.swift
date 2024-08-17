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
    var scrollTo: CGPoint
    
    @Binding var isLoading: Bool

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: urlToLoad) {
            webView.load(URLRequest(url: url))
        }
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: BlogWebView

        init(_ parent: BlogWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = true
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if self.parent.urlToLoad == "https://m.blog.naver.com/hyangyuloum" {
                let x = self.parent.scrollTo.x
                let y = self.parent.scrollTo.y
                let scrollScript = "window.scrollTo(\(x), \(y));"

                webView.evaluateJavaScript(scrollScript) { _, _ in
                     DispatchQueue.main.async {
                         self.parent.isLoading = false
                     }
                 }
            } else {
                DispatchQueue.main.async {
                    self.parent.isLoading = false
                }
            }
        }
    }
}
