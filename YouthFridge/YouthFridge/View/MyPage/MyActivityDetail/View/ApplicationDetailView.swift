//
//  ApplicationDetailView.swift
//  YouthFridge
//
//  Created by 임수진 on 7/23/24.
//

import SwiftUI

struct ApplicationDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ActivityCardViewModel
    @State private var showCancelPopup = false
    @StateObject var detailViewModel: ApplicationDetailModel
    
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
                    }
                }
                .padding(.top, 10)
                
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
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 6)
                Text(viewModel.date)
                    .font(.body)
                Text(viewModel.location)
                    .font(.body)
            }
            .padding()
            
            Spacer()
            
            Text("D - \(viewModel.daysLeft)")
                .font(.title2)
                .fontWeight(.bold)
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
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text("\(detailViewModel.currentMember)/\(detailViewModel.totalMember)명")
                    .font(.subheadline)
                    .fontWeight(.semibold)
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
                    .font(.title3)
                    .fontWeight(.bold)
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
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.bottom, 10)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 204, height: 60)
                            .background(Color.gray1)
                            .cornerRadius(6)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(detailViewModel.activities, id: \.self) { activity in
                                 Text(activity)
                                     .font(Font.custom("Pretendard", size: 12))
                             }
                        }
                        .padding(20)
                        .foregroundColor(Color.gray6)
                    }
                    .padding(.bottom, -10)
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
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                
                Text("원활한 소통을 위해 모임 전 꼭 참여해주세요 !")
                    .font(.caption)
                    .fontWeight(.regular)
            }
                    
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 324, height: 32)
                    .background(Color.gray1)
                    .cornerRadius(6)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(detailViewModel.kakaoLink)
                        .font(Font.custom("Pretendard", size: 12))
                }
                .padding(20)
                .foregroundColor(Color.gray6)
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
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text("모임 2일 전까지만 취소 가능")
                    .font(.subheadline)
                    .fontWeight(.regular)
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
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.gray6)
                            .frame(width: 77, height: 29)
                            .background((viewModel.daysLeft == 2 ? Color.gray2 : Color.sub2))
                            .cornerRadius(8)
                    }
                    .disabled(viewModel.daysLeft == 2)  // daysLeft가 2일 경우 버튼 비활성화
                    .padding(.leading, 15)
                }
                .padding(.bottom, -20)
            }
            .padding(.top, 10)
        }
        .padding()
    }
    
    var rulesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
                .background(Color.gray.opacity(0.5))
            
            HStack {
                Text("참여자 규칙")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                
                Text("운영사항")
                    .font(.subheadline)
                    .fontWeight(.regular)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("* 모임 참여가 어려울 시, 모임 일자 ")
                + Text("기준 2일 전까지")
                    .fontWeight(.bold)
                    .underline()
                + Text(" 미참석 버튼을 눌러 호스트에게 전달해 주세요.")
                Text("* 참여 응답 후 모임 미참석 시, 다음 참여에 불이익이 있을 수 있습니다.")
                Text("* 호스트의 주도로 소모임 내에서 진행되는 활동을 잘 따라주세요.")
                Text("* 불건전한 만남 및 문제 상황 발생을 방지하기 위해 관리자가 상시 모니터링 중입니다.")
                Text("* 문의사항 또는 문제 발생 시 ")
                + Text("문의처")
                    .fontWeight(.bold)
                    .underline()
                + Text("로 문의 부탁드립니다.")
            }
            .font(.footnote)
            .foregroundColor(Color.gray4)
        }
        .padding()
    }
}

struct ApplicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let services = Services()
        let container = DIContainer(services: services)
//        ActivityDetailView(viewModel: ActivityCardViewModel(title: "스시 먹부림", date: "7월 30일 화요일 오후 7시", location: "안서 초등학교", daysLeft: 21, imageName: "image1"))
    }
}
