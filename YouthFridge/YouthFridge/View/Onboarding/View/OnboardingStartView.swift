//
//  OnboardingStartView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct OnboardingStartView: View {
    @State private var selectedIndex: Int = 2
    let images = ["start1", "start2", "start3", "start4", "start5"]

    var body: some View {
            ZStack {
                Color.sub2Color
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Image("whiteLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding(.top,50)
                    
                    Text("오직 천안에서만")
                        .foregroundColor(.black)
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                    HStack {
                        Image("titleLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 142,height: 27)
                        Text("를 만나보세요")
                            .foregroundColor(.black)
                            .font(.system(size: 26,weight: .bold))
                    }
                    Text("우리 천안에서 밥 친구할래?")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    ZStack {
                        Image("phone")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 397)
                            .offset(y: 30)
                        
                        TabView(selection: $selectedIndex) {
                            ForEach(0..<images.count) { index in
                                Image(images[index])
                                    .resizable()
                                    .scaledToFit()
                                    .tag(index)
                                    .padding()
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                    .frame(height: 330)
                    
                    Spacer()
                    
                    NavigationLink(destination: ResearchView().navigationBarBackButtonHidden()) {
                        Text("다음")
                            .font(.headline)
                            .foregroundColor(.yellow)
                            .padding()
                            .frame(maxWidth: 320)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 20)
                }
                .padding()
            }
            .navigationBarHidden(true)
        
    }
}


struct OnboardingStartView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingStartView()
    }
}
