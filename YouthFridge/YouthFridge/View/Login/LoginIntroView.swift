//
//  LoginIntroView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser

struct LoginIntroView: View {
    @State private var isPresentedLoginView: Bool = false
    @State private var appleSignInCoordinator: AppleSignInCoordinator?
    @State private var type: String = ""
    @State private var isPresentedMainTabView: Bool = false
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
                    performKakaoSignIn()
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
                OnboardingStartView().navigationBarBackButtonHidden()
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

    private func performKakaoSignIn() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("카카오톡으로 로그인 성공")
                    self.type = "kakao"
                    UserDefaults.standard.setValue(self.type, forKey: "loginType")
                    self.fetchKakaoUserID()
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("카카오 계정으로 로그인 성공")
                    self.type = "kakao"
                    UserDefaults.standard.setValue(self.type, forKey: "loginType")
                    self.fetchKakaoUserID()
                }
            }
        }
    }
    
    private func fetchKakaoUserID() {
        UserApi.shared.me { (user, error) in
            if let error = error {
                print("카카오 사용자 정보 가져오기 실패: \(error)")
            } else {
                if let user = user {
                    if let id = user.id {
                        let userIDString = String(id)
                        UserDefaults.standard.setValue(userIDString, forKey: "userID")
                        print("카카오 사용자 아이디: \(userIDString)")
                    }
                }
                if let email = user?.kakaoAccount?.email {
                    UserDefaults.standard.setValue(email, forKey: "userEmail")
                    print("카카오 사용자 이메일 : \(email)")
                }
                self.isPresentedLoginView = true
            }
        }
    }
    private func performBackendLogin(userID: String,email:String,type: String) {
        let loginRequest = LoginRequest(email: email, type: type, username: userID, token: <#T##String#>)
        OnboardingAPI.shared.login(loginRequest) { result in
            switch result {
            case .success:
                self.isPresentedMainTabView = true
            case .failure(let error):
                print("로그인 실패: \(error.localizedDescription)")
            }
        }
    }
    private func performAppleSignIn() {
        let coordinator = AppleSignInCoordinator()
        coordinator.startSignInWithAppleFlow(onSuccess: {
            self.type = "apple"
            UserDefaults.standard.setValue(self.type, forKey: "loginType")
            self.isPresentedLoginView = true
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
            UserDefaults.standard.setValue(userIdentifier, forKey: "userID")
            print("Full Name: \(String(describing: fullName))")
            print("Email: \(String(describing: email))")
            
            if let authorizationCode = appleIDCredential.authorizationCode,
               let identityToken = appleIDCredential.identityToken,
               let authString = String(data: authorizationCode, encoding: .utf8),
               let tokenString = String(data: identityToken, encoding: .utf8) {
                print("Authorization Code: \(authString)")
                print("Identity Token: \(tokenString)")
            }
            
            if let email = email {
                UserDefaults.standard.set(email, forKey: "userEmail")
                print("Stored User Email: \(email)")
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
