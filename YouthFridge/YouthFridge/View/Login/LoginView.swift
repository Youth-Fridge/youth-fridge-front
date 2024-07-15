//
//  LoginView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("로그인")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
                .padding(.top, 80)
            Text("아래 제공되는 서비스로 로그인을 해주세요.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
            
            Button {
                
            } label: {
                Text("카카오 로그인")
            }.buttonStyle(LoginButtonStyle(textColor: .yellow, borderColor: .gray,backgroundColor: .white))
            
            Button {
                
            } label: {
                Text("Apple 로그인")
            }.buttonStyle(LoginButtonStyle(textColor: .black, borderColor: .gray,backgroundColor: .white))
        }
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
