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
    @Binding var reload: Bool

    func makeUIView(context: Context) -> WKWebView {
         let webView = WKWebView()
         webView.navigationDelegate = context.coordinator
         webView.scrollView.delegate = context.coordinator
         return webView
     }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: urlToLoad) else { return }
        
        if reload {
            let request = URLRequest(url: url)
            uiView.load(request)
            reload = false
        }
        
        DispatchQueue.main.async {
            uiView.scrollView.setContentOffset(scrollTo, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate, UIScrollViewDelegate {
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
                 DispatchQueue.main.async {
                     self.checkScrollPosition(webView: webView)
                 }
             } else {
                 DispatchQueue.main.async {
                     self.parent.isLoading = false
                 }
             }
        }

        private func checkScrollPosition(webView: WKWebView) {
            let targetOffset = parent.scrollTo
            let contentOffset = webView.scrollView.contentOffset
            
            let offsetX = abs(contentOffset.x - targetOffset.x)
            let offsetY = abs(contentOffset.y - targetOffset.y)
            
            if offsetX < 10 && offsetY < 10 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.parent.isLoading = false
                }
            } else {
                // 일정 시간 후 로딩 종료
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.parent.isLoading = false
                }
            }
        }
    }
}
