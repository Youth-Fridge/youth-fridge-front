//
//  SplashView.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/8/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    
    var body: some View {
        Group {
            if showSplash {
                SplashView(showSplash: $showSplash)
            } else {
                if isTokenValid(KeychainHandler.shared.accessToken) {
                    MainTabView()
                } else {
                    LoginIntroView()
                }
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
        
        if let exp = payloadDict["exp"] as? TimeInterval {
            let expirationDate = Date(timeIntervalSince1970: exp)
            return expirationDate > Date()
        }
        
        return false
    }
}

struct SplashView: View {
    @Binding var showSplash: Bool
    @State private var fadeOut = false
    
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
            .opacity(fadeOut ? 0 : 1)
            .onAppear {
                branchProcessing()
            }
        }
    }
    
    private func branchProcessing() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            withAnimation(.easeOut(duration: 1.0)) {
                fadeOut = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showSplash = false
            }
        }
    }
}


//struct SplashView_Previews: PreviewProvider {
//    static var previews: some View {
//        SplashView()
//    }
//}

