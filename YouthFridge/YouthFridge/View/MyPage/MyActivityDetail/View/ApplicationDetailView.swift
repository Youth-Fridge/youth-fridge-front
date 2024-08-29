//
//  ApplicationDetailView.swift
//  YouthFridge
//
//  Created by 임수진 on 7/23/24.
//

import SwiftUI
import KakaoSDKTalk

struct ApplicationDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ActivityCardViewModel
    @State private var showCancelPopup = false
    @StateObject var detailViewModel: ApplicationDetailModel
    @State private var showToast = false
    @State private var toastMessage = ""
    
    init(invitationId: Int, viewModel: ActivityCardViewModel) {
        self.viewModel = viewModel
        _detailViewModel = StateObject(wrappedValue: ApplicationDetailModel(invitationId: invitationId))
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ShadowNavigationBar()
                
                ScrollView {
                    VStack(spacing: 0) {
                        content
                            .padding(.horizontal, 10)
                            .padding(.leading, 5)
                        
                        ZStack {
                            shadowView
                                .padding(.top, 20)
                                .padding(.bottom, -30)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                participantView
                                toDoSection
                                openChatSection
                                responseSection
                                rulesSection
                            }
                            .padding(.horizontal, 15)
                            .padding(.top, 25)
                        }
                        Spacer()
                            .padding(.bottom, 22)
                    }
                }
                .padding(.top, 10)
                .scrollIndicators(.hidden)
                
                GeometryReader { geometry in
                    if showCancelPopup {
                        Color.black
                            .opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        VStack {
                            CancelPopUpView(
                                message: "미참석 버튼 클릭 시 소모임 참여가 어려워요!",
                                subMessage: "반복적으로 미 응답 누적 시 앞으로의 모임 활동이 힘들어집니다",
                                onClose: {
                                    withAnimation {
                                        showCancelPopup = false
                                    }
                                },
                                onConfirm: {
                                    withAnimation {
                                        showCancelPopup = false
                                        print("미참석 할게요")
                                        detailViewModel.cancelInvitation()
                                        dismiss()
                                    }
                                }
                            )
                            .frame(width: geometry.size.width, height: 700) // 팝업 크기 설정
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut, value: showCancelPopup) // 애니메이션 추가
                        }
                    }
                }
            }
            .navigationTitle("신청 내역")
            .navigationBarTitleDisplayMode(.inline)
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
                Text("참여 현황")
                    .font(.pretendardBold18)
                
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
            .padding(.top, 10)
        }
    }
    
    var toDoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Text("TO DO")
                    .font(.pretendardBold18)
                    .padding(.top, -10)
                    .padding(.bottom, 2)
            }
            .padding()
            
            HStack(alignment: .top, spacing: 10) {
                if let profileImage = ProfileImage.from(rawValue: detailViewModel.ownerProfileImageNumber) {
                    let imageName = profileImage.imageName
                    
                    Image(imageName)
                        .resizable()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .offset(y: -30)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(detailViewModel.ownerIntroduce)
                        .font(.pretendardMedium14)
                        .padding(.bottom, 10)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 204)
                            .background(Color.gray1)
                            .cornerRadius(6)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(detailViewModel.activities, id: \.self) { activity in
                                 Text("•  \(activity)")
                                    .font(.pretendardRegular12)
                                    .padding(.bottom, 3)
                             }
                        }
                        .padding(.leading, 17)
                        .padding(.top, 13)
                        .padding(.bottom, 10)
                        .foregroundColor(Color.gray6)
                    }
                }
                .padding(.leading, 5)
            }
            .padding()
        }
    }
    
    var openChatSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
                .background(Color.gray.opacity(0.5))
            
            HStack {
                Text("오픈채팅")
                    .font(.pretendardBold18)
                    .padding(.bottom, 2)
                
                Text("원활한 소통을 위해 모임 전 꼭 참여해주세요 !")
                    .font(.pretendardRegular12)
                    .foregroundColor(Color.gray6)
                    .fontWeight(.regular)
            }
            .padding(.top, 8)
                    
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 324)
                    .background(Color.gray1)
                    .cornerRadius(6)
                
                if let url = URL(string: detailViewModel.kakaoLink) {
                    Link(destination: url) {
                        Text(detailViewModel.kakaoLink)
                            .font(.pretendardRegular12)
                            .padding(.leading, 5)
                            .padding(12)
                            .foregroundColor(.blue)
                            .underline()
                    }
                } else {
                    Text("Invalid URL")
                        .font(.pretendardRegular12)
                        .padding(.leading, 5)
                        .padding(12)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, -10)
        }
        .padding(.leading, 20)
    }

    
    var responseSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
                .background(Color.gray.opacity(0.5))
            
            VStack(alignment: .leading) {
                Text("신청 취소")
                    .font(.pretendardBold18)
                    .padding(.top, 8)
                
                Text("모임 2일 전까지만 취소 가능")
                    .font(.pretendardRegular12)
                    .padding(.top, -8)
                    .foregroundColor(Color.gray6)
            }
            
            VStack(spacing: 10) {
                HStack {
                    let profileNumber = UserDefaults.standard.integer(forKey: "profileImageNumber")
                    if let profile = ProfileImage.from(rawValue: profileNumber) {
                        let profileImage = profile.imageName
                        
                        Image(profileImage)
                            .resizable()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    }
                
                    Button(action: {
                        showCancelPopup = true
                    }) {
                        Text("미참석")
                            .font(.pretendardSemiBold14)
                            .foregroundColor(Color.gray6)
                            .frame(width: 77, height: 29)
                            .background((viewModel.daysLeft <= 1 ? Color.gray2 : Color.sub2))
                            .cornerRadius(8)
                    }
                    .disabled(viewModel.daysLeft <= 1)  // daysLeft가 1보다 작거나 같은 경우 버튼 비활성화
                    .padding(.leading, 15)
                }
                .padding(.bottom, -20)
            }
            .padding(.top, 8)
        }
        .padding()
    }
    
    var rulesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
                .background(Color.gray.opacity(0.5))
            
            HStack {
                Text("참여자 규칙")
                    .font(.pretendardBold18)
                    .padding(.bottom, 2)
                
                Text("운영사항")
                    .font(.pretendardRegular12)
                    .foregroundColor(Color.gray6)
                    .padding(.bottom, 2)
            }
            .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("*본인이 오픈채팅에 참여하지 않아 생기는 문제의 경우 책임지지 않습니다. 모임 일자 이전 꼭 ")
                + Text("오픈채팅 참여")
                    .fontWeight(.bold)
                    .underline()
                + Text("를 통해 원활한 소통 부탁드립니다.")
                Text("*모임 참여가 어려울 시, 모임 일자 ")
                + Text("기준 2일 전까지")
                    .fontWeight(.bold)
                    .underline()
                + Text(" 미참석 버튼을 눌러 호스트에게 전달해 주세요.")
                Text("*만약 모임 당일 참여가 불가피 할 경우 오픈채팅방을 통해 참여 불가능 의사를 호스트에게 전달해 주세요.")
                Text("*참여 응답 후 모임 미참석 시, 다음 참여에 불이익이 있을 수 있습니다.")
                Text("*호스트의 주도로 소모임 내에서 진행되는 활동을 잘 따라주세요.")
                Text("*불건전한 만남 및 문제 상황 발생을 방지하기 위해 관리자가 상시 모니터링 중입니다.")
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
            .padding(.bottom, 40)
            .font(.pretendardMedium11)
            .foregroundColor(Color.gray4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
    }
}
