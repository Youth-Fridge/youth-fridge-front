//
//  InviteFinalView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/24/24.
//

import SwiftUI

struct InviteFinalView: View {
    @State private var selectedTab: MainTabType = .mypage
    @StateObject private var smallClassViewModel = SmallClassViewModel()

    var body: some View {
        VStack {
            Spacer()
            Image("logo")
                .resizable()
                .frame(width: 70,height: 70)
                .padding()
            Image("titleLogo")
                .resizable()
                .frame(width: 140,height: 26)
                .padding()
            Text("건강한 청년의\n 식문화 함께 만들어요!")
                .font(.system(size: 32,weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray6)
                .padding()
            
            Spacer()
            // MARK: -- 나의 신청내역 이동
            NavigationLink(destination: MyActivityView(selectedTab: 1, viewModel: MyPageViewModel(container: DIContainer(services: Services())), profileViewModel: smallClassViewModel)) {
                Text("신청한 모임 확인하기")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 320)
                    .background(Color.sub2)
                    .cornerRadius(8)
            }
            .padding()
            .onTapGesture {
                selectedTab = .mypage
            }
            .navigationBarBackButtonHidden(true)
            VStack {
                Text("* 일정 변경으로 참여가 어려울 시 반드시 2일 전에는 응답해 주세요.")
                    .font(.system(size: 11,weight: .medium))
                    .foregroundColor(.gray4)
                Text("* 불건전한 만남 및 문제 상황 발생을 방지하기 위해 관리자가 상시 \n 모니터링 중입니다.")
                    .font(.system(size: 11,weight: .medium))
                    .foregroundColor(.gray4)
                    .padding(.bottom,75)
            }
        }
    }
    
}


