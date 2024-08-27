//
//  SplashView.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/8/24.
//

import SwiftUI

enum TokenType: String {
    case apple
    case kakao
}

struct ContentView: View {
    @State private var showSplash = true
    
    var body: some View {
        Group {
            if showSplash {
                SplashView(showSplash: $showSplash)
            } else {
                // UserDefaults에서 저장된 loginType 가져오기
                if let tokenTypeString = UserDefaults.standard.string(forKey: "loginType"),
                   let tokenType = TokenType(rawValue: tokenTypeString) {
                    let accessToken = KeychainHandler.shared.accessToken
                    
                    // 액세스 토큰이 비어있는지 확인
                    if accessToken.isEmpty {
                        LoginIntroView()
                    } else {
                        // 토큰의 유효성 검사
                        if isTokenValid(accessToken, type: tokenType) {
                            MainTabView()
                        } else {
                            LoginIntroView()
                        }
                    }
                } else {
                    // loginType이 UserDefaults에 없거나 변환에 실패한 경우
                    LoginIntroView()
                }
            }
        }
    }
    
    private func isTokenValid(_ token: String, type: TokenType) -> Bool {
        switch type {
        case .apple:
            return isAppleTokenValid(token)
        case .kakao:
            return isKakaoTokenValid(token)
        }
    }
    
    private func isAppleTokenValid(_ token: String) -> Bool {
        if let expirationTime = UserDefaults.standard.value(forKey: "tokenExpirationTime") as? Date {
            return Date() < expirationTime
        }
        return false
    }
    
    private func isKakaoTokenValid(_ token: String) -> Bool {
        let parts = token.split(separator: ".")
        guard parts.count == 3 else { return false }
        
        let payload = parts[1]
        guard let payloadData = Data(base64Encoded: String(payload)) else { return false }
        
        guard let json = try? JSONSerialization.jsonObject(with: payloadData, options: []),
              let payloadDict = json as? [String: Any] else { return false }
        
        if let exp = payloadDict["exp"] as? TimeInterval {
            let expirationDate = Date(timeIntervalSince1970: exp)
            return expirationDate > Date()
        }
        
        return false
    }
}

struct SplashView: View {
    @Binding var showSplash: Bool
    
    var body: some View {
        ZStack {
            Color.sub2Color
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Image("whiteLogo")
                    .resizable()
                    .frame(width: 84, height: 84)
                    .padding(.top, 170)
                
                Image("titleLogo")
                    .resizable()
                    .frame(width: 205, height: 38)
                    .padding(.top, 36)
                
                GeometryReader { geometry in
                    Image("invitationLogo")
                        .resizable()
                        .frame(width: 290, height: 421)
                        .position(x: geometry.size.width - 130, y: geometry.size.height - 180)
                }
                
                Spacer()
                
                Text("Copyright © Hyangyuloium. All Rights Reserved.")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray4)
                    .padding(.bottom, 30)
            }
            .onAppear {
                branchProcessing()
            }
        }
    }
    
    private func branchProcessing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showSplash = false
        }
    }
}

