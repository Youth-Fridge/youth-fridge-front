//
//  StartView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 175)
            Image("logo")
                .resizable()
                .frame(width:70,height: 70)
                .padding(.bottom)
            Image("titleLogo")
                .resizable()
                .frame(width: 140,height: 26)
            Text("만나서 반가워요")
                .font(.system(size: 40, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.top)
            Text("든든히 한 끼 함께 해요!")
                .font(.system(size: 24, weight: .medium))
                .multilineTextAlignment(.center)
            
           Spacer()
            NavigationLink(destination: MainTabView().navigationBarBackButtonHidden()) {
                Text("동네친구 사귀고 함께 시작하기")
                    .font(.system(size: 16,weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 320)
                    .background(Color.yellow)
                    .cornerRadius(8)
            }
                
        }
        
    }
}

#Preview {
    StartView()
}
