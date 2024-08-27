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

         // URL이 로드되었는지 확인 후 스크롤 위치 조정
         if let currentURL = uiView.url?.absoluteString, currentURL.starts(with: urlToLoad) {
             DispatchQueue.main.async {
                 if urlToLoad == "https://m.blog.naver.com/hyangyuloum" {
                     uiView.scrollView.setContentOffset(scrollTo, animated: true)
                 }
             }
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
            guard let currentURL = webView.url?.absoluteString else {
                DispatchQueue.main.async {
                    self.parent.isLoading = false
                }
                return
            }
            
            let baseURL = "https://m.blog.naver.com/hyangyuloum"
            
            if currentURL.starts(with: baseURL) {
                if currentURL == baseURL {
                    DispatchQueue.main.async {
                        self.checkScrollPosition(webView: webView, forBaseURL: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.checkScrollPosition(webView: webView, forBaseURL: false)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.parent.isLoading = false
                }
            }
        }

        private func checkScrollPosition(webView: WKWebView, forBaseURL: Bool) {
            let targetOffset: CGPoint
            
            if forBaseURL {
                targetOffset = self.parent.scrollTo
            } else {
                targetOffset = CGPoint(x: 0, y: 100)
            }
            
            let contentOffset = webView.scrollView.contentOffset
            let offsetX = abs(contentOffset.x - targetOffset.x)
            let offsetY = abs(contentOffset.y - targetOffset.y)
            
            if offsetX < 10 && offsetY < 10 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.parent.isLoading = false
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.parent.isLoading = false
                }
            }
        }
    }
}
