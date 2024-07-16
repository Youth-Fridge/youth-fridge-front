//
//  OnboardingStartView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct OnboardingStartView: View {
    var body: some View {
        ZStack {
            Color.sub2Color
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                
                Text("오직 천안에서만\n 청년냉장고를 만나보세요")
                    .foregroundColor(.black)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text("우리 천안에서 밥 친구할래?")
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Image("phone")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 330)
            }
            .padding()
            
            VStack {
                Spacer()
                Button(action: {
                   
                }) {
                    Text("다음")
                        .font(.headline)
                        .foregroundColor(.sub2Color)
                        .padding()
                        .frame(maxWidth: 320)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                }
                .padding()
            }
        }
    }
}

struct OnboardingStartView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingStartView()
    }
}
