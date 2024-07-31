//
//  LoginIntroView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI

struct LoginIntroView: View {
    @State private var isPresentedLoginView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 84,height: 84)
                Image("titleLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 205,height: 38)
                
                Text("천안에 사는 청년들을 위한\n 건강한 밥 한끼")
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Text(attributedText)
                                    .font(.system(size: 14))
                
                Button {
                   
                } label: {
                    HStack {
                        Image(systemName: "message.fill")
                            .frame(height: 48)
                        Text("카카오톡 로그인")
                            .font(.system(size: 16,weight: .semibold))
                    }
                }.buttonStyle(LoginButtonStyle(textColor: .gray6, borderColor: .kakaoColor, backgroundColor: .kakaoColor))
                Button {
                  
                } label: {
                    HStack {
                        Image(systemName: "applelogo")
                            .frame(height: 48)
                        Text("Apple 로그인")
                            .font(.system(size: 16,weight: .semibold))
                    }
                }.buttonStyle(LoginButtonStyle(textColor: .white, borderColor: .gray6Color, backgroundColor: .gray6Color))
                Text("로그인 오류 시 문의 청년냉장고")
                    .font(.system(size: 12))
                    .foregroundColor(Color.gray4)
            }
            .navigationDestination(isPresented: $isPresentedLoginView) {
               
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
}

struct LoginIntroView_Previews: PreviewProvider {
    static var previews: some View {
        LoginIntroView()
    }
}
