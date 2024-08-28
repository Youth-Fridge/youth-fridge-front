//
//  ShowInviteView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/23/24.
//

import SwiftUI

struct ShowInviteView: View {
    @ObservedObject var viewModel: ShowInviteViewModel
    let invitationId: Int
    let recruiting: String
    @State private var isImageVisible: Bool = true
    @State private var rotationAngle: Double = 0
    @State private var isFlipped: Bool = false
    @State private var isInvitationApplied: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showGIF: Bool = true
    @Environment(\.presentationMode) var presentationMode
    @State private var showComplainPopupView = false
    private let hapticManager = HapticManager.instance //진동
    var body: some View {
            ZStack {
                Color.sub2
                    .edgesIgnoringSafeArea(.all)
                if showGIF {
                    GifView(gifName: "motion")
                        .edgesIgnoringSafeArea(.all)
                }
                GeometryReader { geometry in
                    Image("invitationLogo")
                        .resizable()
                        .frame(width: 280, height: 387)
                        .position(x: geometry.size.width - 140, y: geometry.size.height - 160)
                    
                    VStack(alignment: .center) {
                        Text("당신을 초대합니다 🎉")
                            .font(.pretendardBold30)
                            .foregroundColor(.gray6)
                            .padding(.top ,20)
                        
                        ZStack {
                            Image("invitation")
                                .resizable()
                                .scaledToFit() // 이미지가 프레임 안에 맞도록 비율 유지
                                .frame(width: geometry.size.width * 0.9, height: (geometry.size.width * 0.9) * 4 / 2)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - 100) // 위치 조정
                                .padding(.leading, 15) // 왼쪽 여백 추가
                        
                            
                            if isImageVisible {
                                VStack {
                                    if let showDetail = viewModel.showDetail,
                                       let invitationImage = PublicInvitationImage.from(rawValue: showDetail.invitationImage) {
                                        
                                        Image(invitationImage.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: geometry.size.width * 0.89, height: (geometry.size.width * 0.89) * 4 / 3.8)
                                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - 140)
                                        if let showDetail = viewModel.showDetail, !showDetail.official {
                                            Text(showDetail.clubName)
                                                .font(.pretendardBold20)
                                                .foregroundColor(.gray6)
                                                .position(x: geometry.size.width / 2,y: geometry.size.height / 2 - 200)
                                        } else {
                                            Text(showDetail.clubName)
                                                .font(.pretendardBold20)
                                                .foregroundColor(.gray6)
                                                .position(x: geometry.size.width / 2,y: geometry.size.height / 2 - 210)
                                        }
                                    }
                                }
                                .padding(.top,-20)
                            }
                            
                            // MARK: - 뒷 배경
                            else {
                                if let showDetail = viewModel.showDetail {
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack {
                                            if let profileImageName = ProfileImage.from(rawValue: showDetail.ownerProfile)?.imageName {
                                                Image(profileImageName)
                                                    .resizable()
                                                    .frame(width: 54, height: 54)
                                                
                                                Text(showDetail.clubName)
                                                    .font(.pretendardSemiBold16)
                                                    .foregroundColor(.gray6)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(.top,-15)
                                        
                                        VStack(alignment: .leading, spacing: 10) {
                                            Divider()

                                            Text("기간")
                                                .font(.pretendardBold16)
                                                .padding(.top,10)
                                                .foregroundColor(.gray6)

                                            HStack {
                                                Text("우리 약속까지 ")
                                                    .font(.pretendardMedium14)
                                                    .foregroundColor(.gray6)
                                                
                                                Text(showDetail.dday)
                                                    .font(.pretendardBold20)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(Color.sub3Color)
                                                
                                                Text("일 남았어요")
                                                    .font(.pretendardMedium14)
                                                    .foregroundColor(.gray6)
                                                
                                            }
                                            Spacer()
                                            
                                            Text("인원")
                                                .font(.pretendardBold16)
                                                .foregroundColor(.gray6)
                                            
                                            
                                            Text("\(showDetail.number)명")
                                                .font(.pretendardMedium14)
                                                .foregroundColor(.gray6)
                                            Spacer()
                                            
                                            Text("시간 및 장소")
                                                .font(.pretendardBold16)
                                                .foregroundColor(.gray6)
                                            
                                            
                                            Text(showDetail.time)
                                                .font(.pretendardMedium14)
                                                .foregroundColor(.gray6)
                                            Text(showDetail.place)
                                                .font(.pretendardMedium14)
                                                .foregroundColor(.gray6)
                                            Spacer()
                                            Text("TO DO")
                                                .font(.pretendardBold16)
                                                .foregroundColor(.gray6)
                                            
                                            
                                            VStack(alignment: .leading) {
                                                ForEach(showDetail.todo.split(separator: "\n"), id: \.self) { todo in
                                                    Text("• \(todo)")
                                                        .foregroundColor(.gray6)
                                                        .font(.pretendardMedium14)
                                                    
                                                }
                                                
                                            }
                                            .frame(height: 50)
                                            Spacer()
                                        }
                                    }
                                    .padding(30)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                                    .frame(width: geometry.size.width * 0.8, height: (geometry.size.width * 0.8) * 3 / 4)
                                } else {
                                    Text("Loading...")
                                }
                            }
                        }
                        .rotation3DEffect(
                            .degrees(rotationAngle),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .scaleEffect(isFlipped ? CGSize(width: -1, height: 1) : CGSize(width: 1, height: 1))
                        
                        .onTapGesture {
                            hapticManager.impact(style: .heavy)
                            withAnimation(.easeInOut(duration: 0.8)) {
                                rotationAngle += 180
                                if rotationAngle == 180 {
                                    isImageVisible.toggle()
                                } else if rotationAngle == 360 {
                                    rotationAngle = 0
                                    isImageVisible.toggle()
                                }
                            }
                            DispatchQueue.main.async {
                                isFlipped.toggle()
                            }
                        }
                        

                        Button(action: {
                            applyInvitation()
                        }) {
                            Text("참여하기")
                                .font(.pretendardBold20)
                                .foregroundColor(viewModel.isAvailable ? Color.sub2: Color.gray6)
                                .padding()
                                .frame(maxWidth: 320)
                                .background(viewModel.isAvailable ? Color.white: Color.gray2)
                                .cornerRadius(8)
                                .shadow(radius: 3)
                        }
                        .disabled(isInvitationApplied || !viewModel.isAvailable)
                        Button(action: {
                            reportInvitation()
                        }) {
                            if let showDetail = viewModel.showDetail, !showDetail.official {
                                Text("커뮤니티 규정에 어긋난 소모임인가요?")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray7)
                                    .underline(color: .gray7)
                                    .padding(.top, 10)
                            }
                        }
                        .padding(.bottom,40)
                        NavigationLink(
                            destination: InviteFinalView(),
                            isActive: $isInvitationApplied,
                            label: { EmptyView() }
                        )
                    }}
                    if showComplainPopupView {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    showComplainPopupView = false
                                }
                            }
                        ComplainPopUpView(
                            message: "보다 건강한 커뮤니티를 위한\n 소중한 의견 감사합니다",
                            onConfirm: {
                                withAnimation {
                                    showComplainPopupView = false
                                }
                            }
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .zIndex(1)
                    }
                }
            
            
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }){
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            })
            
            .onAppear {
                viewModel.fetchInviteData(invitationId: invitationId)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("알림"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            }
    }
    
    private func applyInvitation() {
        // TODO: - 이미 신청한 소모임인 경우 처리
        // 모집 중일 경우 소모임 신청
        if recruiting == "모집 중" {
            InvitationService.shared.applyInvitation(invitationId: invitationId) { result in
                switch result {
                case .success(let message):
                    isInvitationApplied = true
                case .failure(let error):
                    DispatchQueue.main.async {
                        alertTitle = "오류"
                        alertMessage = error.localizedDescription
                        showAlert = true
                    }
                }
            }
        } else {
            alertTitle = "오류"
            alertMessage = "모집 완료된 소모임입니다."
            showAlert = true
        }
    }
    
    private func reportInvitation() {
        InvitationService.shared.reportInvitation(invitationId: invitationId) { result in
            switch result {
            case .success(let message):
                showComplainPopupView = true
                print("소모임 신고가 완료되었습니다")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    if let customErrorMessage = error.localizedDescription as? String,
                       customErrorMessage == "이미 신고하였습니다." {
                        alertTitle = "오류"
                        alertMessage = "이미 신고한 소모임입니다."
                        showAlert = true
                    }
                }
            }
        }
    }
}
