//
//  OnboardingStartView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct OnboardingStartView: View {
    @State private var selectedIndex: Int = 2 // Start with the third card centered

    var body: some View {
        NavigationView {
            ZStack {
                Color.sub2Color
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    
                    Text("오직 천안에서만\n청년냉장고를 만나보세요")
                        .foregroundColor(.black)
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                    
                    Text("우리 천안에서 밥 친구할래?")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.bottom, 30)
                    
                    Spacer()
                    
                    ZStack {
                        Image("phone")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 397)
                            .offset(y: 30)
                        
                        TabView(selection: $selectedIndex) {
                            
                            ForEach(0..<5) { index in
                                NumberCardView(index: index)
                                    .tag(index)
                                    .padding()
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                    .frame(height: 330)
                    
                    Spacer()
                    
                    NavigationLink(destination: ResearchView()) {
                        Text("다음")
                            .font(.headline)
                            .foregroundColor(.yellow)
                            .padding()
                            .frame(maxWidth: 320)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 30)
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

struct NumberCardView: View {
    let index: Int
    let titles = ["취업\n레터", "밥심레터", "생활백서", "이 주의\n장금이", "초대의\n만들기"]
    let colors: [Color] = [.onboarding1, .main1Color, .sub3Color, .onboarding4, .onboarding5]

    var body: some View {
        VStack {
            Text("\(index + 1)")
                .foregroundColor(.white)
                .font(.system(size: 52, weight: .bold))
                .padding(.top, 30)
            
            Spacer()

            Text(titles[index])
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.bottom,30)
        }
        .frame(width: 80, height: 200)
        .background(colors[index])
        .cornerRadius(8)
        .shadow(radius: 5)
        .padding(5)
    }
}


struct OnboardingStartView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingStartView()
    }
}
