//
//  ActivityDetailView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI
import KakaoSDKTalk

struct ActivityDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ActivityCardViewModel
    @StateObject var detailViewModel: ActivityDetailModel
    init(invitationId: Int, viewModel: ActivityCardViewModel) {
        self.viewModel = viewModel
        _detailViewModel = StateObject(wrappedValue: ActivityDetailModel(invitationId: invitationId))
    }
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ShadowNavigationBar()
                
                VStack(spacing: 0) {
                    content
                        .padding(.horizontal, 10)
                        .padding(.leading, 5)
                    
                    ZStack {
                        shadowView
                            .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            participantView
                            rulesSection
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .padding(.top, 10)
            }
            .navigationTitle("신청 내역")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                detailViewModel.fetchDetailActivities()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image("left-arrow")
                            .resizable()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    let profileNumber = UserDefaults.standard.integer(forKey: "profileImageNumber")
                    if let profile = ProfileImage.from(rawValue: profileNumber) {
                        let profileImage = profile.imageName
                        
                        Image(profileImage)
                            .resizable()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
    
    var content: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.title)
                    .font(.pretendardSemiBold20)
                    .padding(.bottom, 6)
                Text(viewModel.date)
                    .font(.pretendardRegular14)
                Text(viewModel.location)
                    .font(.pretendardRegular14)
            }
            .padding()
            
            Spacer()
            
            Text("D - \(viewModel.daysLeft)")
                .font(.pretendardBold20)
                .padding()
                .frame(width: 100, height: 60)
                .background(Color.research)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.main1, lineWidth: 1)
                )
                .padding(.bottom, 20)
                .padding(.trailing, 20)
        }
    }
    
    var shadowView: some View {
        Rectangle()
            .foregroundColor(.clear)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.15),
                radius: 25
            )
             .edgesIgnoringSafeArea(.all)
    }
    
    var participantView: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 15) {
                Text("참여자 명")
                    .font(.pretendardBold18)
                    .padding(.leading, 4)
                
                Text("\(detailViewModel.currentMember)/\(detailViewModel.totalMember)명")
                    .font(.pretendardBold12)
                    .padding(.horizontal, 8)
                    .frame(width: 75, height: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.main1, lineWidth: 1)
                    )
            }
            .padding()
            .padding(.top, calculateTopPadding())
            
            if detailViewModel.memberInfoList.isEmpty {
                // 빈 경우 메시지 표시
                VStack {
                    Spacer()
                        .frame(height: 90)
                    Text("함께할 참여자를 기다리고 있어요 :)")
                        .font(.pretendardRegular16)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                        .frame(height: 90)
                }
                .padding(.horizontal, 16)
            } else {
                // 참여자 목록이 있는 경우 표시
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(detailViewModel.memberInfoList.indices, id: \.self) { index in
                        let participant = detailViewModel.memberInfoList[index]
                        VStack {
                            if let profileImage = ProfileImage.from(rawValue: participant.profileNumber) {
                                let imageName = profileImage.imageName
                                
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            }

                            Text(participant.nickName)
                                .font(.pretendardMedium14)
                                .padding(.top, 4)
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, -15)
            }
        }
    }
    
    var rulesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
                .background(Color.gray.opacity(0.5))
                .padding(.vertical, 5)
            
            HStack {
                Text("호스트 규칙")
                    .font(.pretendardBold18)
                    .padding(.bottom, 2)
                
                Text("운영사항")
                    .font(.pretendardRegular12)
                    .foregroundColor(.gray)
                    .padding(.bottom, 2)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("*소모임 내에서 진행되는 모든 사항들은 호스트에게 달려있습니다.")
                Text("*불건전한 만남 및 문제 상황 발생을 방지하기 위해 관리자가 상시 모니터링 중입니다.")
                Text("*우수 소모임 호스트로 지정 시 리워드가 주어질 수 있습니다.")
                HStack(spacing: 0) {
                    Text("*문의사항 또는 문제 발생 시 ")
                    Button(action: {
                        if let url = URL(string: "http://pf.kakao.com/_kxlxjyG") {
                            UIApplication.shared.open(url)
                        }
//                        TalkApi.shared.chatChannel(channelPublicId: "YOUR_CHANNEL_ID") { error in
//                            if let error = error {
//                                print("Failed to open channel: \(error)")
//                            } else {
//                                print("chatChannel() success.")
//                            }
//                        }
                    }) {
                        Text("문의처")
                            .fontWeight(.bold)
                            .underline()
                    }
                    Text("로 문의 부탁드립니다.")
                }
            }
            .font(.pretendardMedium12)
            .foregroundColor(Color.gray4)
        }
        .padding()
        .padding(.leading, 4)
    }
    
    // 참여자 수에 따라 여백 조정
    private func calculateTopPadding() -> CGFloat {
        let count = detailViewModel.memberInfoList.count
        if count > 0 && count <= 4 {
            return -72
        } else {
            return 30
        }
    }
}
