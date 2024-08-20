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
import SwiftKeychainWrapper

struct LoginIntroView: View {
    @State private var isPresentedLoginView: Bool = false
    @State private var appleSignInCoordinator: AppleSignInCoordinator?
    @State private var isPresentedMainTabView: Bool = false
    @State private var type: String = ""
    @State private var kakaoToken: String? = nil
    @State private var isNewUser: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Spacer()
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 84, height: 84)
                Image("titleLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 205, height: 38)
                    .padding(.top,20)
                
                Text("천안에 사는 청년들을 위한\n 건강한 밥 한끼")
                    .font(.system(size: 18,weight: .medium))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top,5)
                
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
            .navigationDestination(isPresented: $isPresentedMainTabView) {
                destinationView
            }
        }
    }
    
    private var destinationView: some View {
        Group {
            if isNewUser {
                OnboardingStartView()
            } else {
                MainTabView()
            }
        }
        .navigationBarBackButtonHidden()
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
                    self.kakaoToken = oauthToken?.accessToken
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
                    self.kakaoToken = oauthToken?.accessToken
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
                if let token = self.kakaoToken {
                    print("token값:\(token)")
                    self.performBackendLogin(type: UserDefaults.standard.string(forKey: "loginType") ?? "",userID: UserDefaults.standard.string(forKey: "userID") ?? "", email: UserDefaults.standard.string(forKey: "userEmail") ?? "")
                }
            }
        }
    }
    
    private func performBackendLogin(type: String, userID: String, email: String) {
        let loginRequest = LoginRequest(email: email, username: userID)
        print(loginRequest)
        let nicknameKey = type == "apple" ? "appleUserNickname" : "kakaoUserNickname"
        let nickname = UserDefaults.standard.string(forKey: nicknameKey) ?? "Unknown"
        print("사용자 닉네임: \(nickname)")

        OnboardingAPI.shared.login(loginRequest) { result in
            switch result {
            case .success(()):
                self.isPresentedMainTabView = true
                print("로그인 성공")
                
            case .failure(let error):
                let nsError = error as NSError
                switch nsError.code {
                case 400:
                    self.isNewUser = true
                    self.isPresentedLoginView = true
                    print("회원가입 필요")
                    
                default:
                    print("로그인 실패: \(nsError.localizedDescription)")
                }
            }
        }
    }
    
    
    private func performAppleSignIn() {
        let coordinator = AppleSignInCoordinator()
        coordinator.startSignInWithAppleFlow(onSuccess: {
            self.type = "apple"
            UserDefaults.standard.setValue(self.type, forKey: "loginType")
            
            let currentTime = Date()
            UserDefaults.standard.setValue(currentTime, forKey: "tokenIssueTime")
            
            if let expirationTime = Calendar.current.date(byAdding: .day, value: 1, to: currentTime) {
                UserDefaults.standard.setValue(expirationTime, forKey: "tokenExpirationTime")
            }
            
            
            self.performBackendLogin(type: UserDefaults.standard.string(forKey: "loginType") ?? "", userID: UserDefaults.standard.string(forKey: "userID") ?? "", email: UserDefaults.standard.string(forKey: "userEmail") ?? "")
            
        }, onFailure: { error in
            print("Sign in with Apple failed: \(error.localizedDescription)")
        })
        appleSignInCoordinator = coordinator
    }
    
    private func isTokenValid() -> Bool {
        if let expirationTime = UserDefaults.standard.value(forKey: "tokenExpirationTime") as? Date {
            return Date() < expirationTime
        }
        return false
    }
    
    private func ensureValidTokenAndProceed(action: @escaping () -> Void) {
        if isTokenValid() {
            action()
        } else {
            performAppleSignIn()
        }
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
