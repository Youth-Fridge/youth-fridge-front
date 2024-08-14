//
//  SplashView.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/8/24.
//

import SwiftUI

struct SplashView: View {
    @State private var navigateToSignUp = false
    @State private var navigateToMain = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.sub2Color
                    .ignoresSafeArea()
                
                VStack {
                    Spacer().frame(height: 175)
                    
                    Image("whiteLogo")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .padding(.bottom)
                    
                    Image("titleLogo")
                        .resizable()
                        .frame(width: 140, height: 26)
                    
                    Spacer()
                    
                    Text("Copyright © Hyangyuloium. All Rights Reserved.")
                        .font(.system(size: 12))
                        .foregroundColor(.black)
                        .padding(.bottom, 30)
                }
                .onAppear {
                    branchProcessing()
                }
            }
            .navigationDestination(isPresented: $navigateToSignUp) {
                LoginIntroView().navigationBarBackButtonHidden()
            }
            .navigationDestination(isPresented: $navigateToMain) {
                MainTabView().navigationBarBackButtonHidden()
            }
        }
    }
    
    private func branchProcessing() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            let accessToken = KeychainHandler.shared.accessToken
            print("accesstoken: \(accessToken)")
            if accessToken.isEmpty || !isTokenValid(accessToken) {
                navigateToSignUp = true
            } else {
                navigateToMain = true
            }
        }
    }
    func isTokenValid(_ token: String) -> Bool {
        let parts = token.split(separator: ".")
        guard parts.count == 3 else { return false }

        let payload = parts[1]
        guard let payloadData = Data(base64Encoded: String(payload)) else { return false }
        
        guard let json = try? JSONSerialization.jsonObject(with: payloadData, options: []),
              let payloadDict = json as? [String: Any] else { return false }

        // 만료 시간(`exp`)을 확인
        if let exp = payloadDict["exp"] as? TimeInterval {
            let expirationDate = Date(timeIntervalSince1970: exp)
            return expirationDate > Date() // 현재 시간과 비교
        }
        
        return false
    }
    
//    private func logout() {
//        // 액세스 토큰을 삭제하는 예제
//        KeychainHandler.shared.accessToken = ""
//        
//        // 로그아웃 후 로그인 페이지로 이동
//        navigateToSignUp = true
//    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

