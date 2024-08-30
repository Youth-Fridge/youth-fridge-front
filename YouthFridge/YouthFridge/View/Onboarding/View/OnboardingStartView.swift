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
                    .font(.pretendardSemiBold24)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                HStack {
                    Image("titleLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 142,height: 27)
                    Text("를 만나보세요")
                        .foregroundColor(.black)
                        .font(.pretendardExtraBold26)
                }
                Text("우리 천안에서 밥 친구할래?")
                    .font(.pretendardRegular16)
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
                    
                    CarouselView(items: [
                        StepCardViewModel(number: "1", title: "생활밥서", subtitle: "밥심 챙기자", subtitle2: "안서동 소모임", backgroundColor: .onboarding1),
                        StepCardViewModel(number: "2", title: "초대장\n만들기", subtitle: "내가 만든 초대장으로", subtitle2: "밥친구 모아요", backgroundColor: .main1),
                        StepCardViewModel(number: "3", title: "밥심레터", subtitle: "밥에 대한", subtitle2: "이모저모 소식지", backgroundColor: .onboarding3),
                        StepCardViewModel(number: "4", title: "이 주의\n장금이", subtitle: "나만의 레시피로", subtitle2: "장금이 되기", backgroundColor: .onboarding4),
                        StepCardViewModel(number: "5", title: "밥업\n스토어", subtitle: "찾아가는", subtitle2: "안서동 과일가게", backgroundColor: .onboarding5)
                    ])
                    .frame(height: 250)
                    .offset(y: 0)
                }
                .frame(height: 330)
                
                Spacer()
                
                NavigationLink(destination: ResearchView().navigationBarBackButtonHidden()) {
                    Text("다음")
                        .font(.pretendardBold20)
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
