//
//  LoginIntroView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI
import AuthenticationServices

struct LoginIntroView: View {
    @State private var isPresentedLoginView: Bool = false
    @State private var appleSignInCoordinator: AppleSignInCoordinator?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 84, height: 84)
                Image("titleLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 205, height: 38)
                
                Text("천안에 사는 청년들을 위한\n 건강한 밥 한끼")
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Text(attributedText)
                    .font(.system(size: 14))
                
                Button {
                    // 카카오톡 로그인 로직 추가
                } label: {
                    HStack {
                        Image(systemName: "message.fill")
                            .frame(height: 48)
                        Text("카카오톡 로그인")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }.buttonStyle(LoginButtonStyle(textColor: .gray6, borderColor: .kakaoColor, backgroundColor: .kakaoColor))
                
                Button {
                    performAppleSignIn()
                } label: {
                    HStack {
                        Image(systemName: "applelogo")
                            .frame(height: 48)
                        Text("Apple 로그인")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }.buttonStyle(LoginButtonStyle(textColor: .white, borderColor: .gray6Color, backgroundColor: .gray6Color))
                
                Text("로그인 오류 시 문의 청년냉장고")
                    .font(.system(size: 12))
                    .foregroundColor(Color.gray4)
            }
            .navigationDestination(isPresented: $isPresentedLoginView) {
                // 로그인 뷰 로직 추가
            }
        }
    }
    
    var attributedText: AttributedString {
        var text = AttributedString("1분이면 회원가입 가능해요")
        if let range = text.range(of: "1분") {
            text[range].foregroundColor = .sub3Color
        }
        return text
    }
    
    private func performAppleSignIn() {
        let coordinator = AppleSignInCoordinator()
        coordinator.startSignInWithAppleFlow(onSuccess: {
        }, onFailure: { error in
            print("Sign in with Apple failed: \(error.localizedDescription)")
        })
        appleSignInCoordinator = coordinator
    }
}

class AppleSignInCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private var onSuccess: (() -> Void)?
    private var onFailure: ((Error) -> Void)?
    
    func startSignInWithAppleFlow(onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        self.onSuccess = onSuccess
        self.onFailure = onFailure
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("User ID: \(userIdentifier)")
            print("Full Name: \(String(describing: fullName))")
            print("Email: \(String(describing: email))")
            
            if let authorizationCode = appleIDCredential.authorizationCode,
               let identityToken = appleIDCredential.identityToken,
               let authString = String(data: authorizationCode, encoding: .utf8),
               let tokenString = String(data: identityToken, encoding: .utf8) {
                print("Authorization Code: \(authString)")
                print("Identity Token: \(tokenString)")
            }
            
            onSuccess?()
            
        case let passwordCredential as ASPasswordCredential:
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("Username: \(username)")
            print("Password: \(password)")
            
            onSuccess?()
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple failed: \(error.localizedDescription)")
        onFailure?(error)
    }
}
