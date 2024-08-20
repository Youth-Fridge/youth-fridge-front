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
    
    @State private var isImageVisible: Bool = true
    @State private var rotationAngle: Double = 0
    @State private var isFlipped: Bool = false
    @State private var isInvitationApplied: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showGIF: Bool = true
    @Environment(\.presentationMode) var presentationMode
    private let hapticManager = HapticManager.instance //진동
    var body: some View {
            ZStack {
                Color.sub2
                    .edgesIgnoringSafeArea(.all)
                if showGIF {
                    GifView(gifName: "motion")
                        .edgesIgnoringSafeArea(.top)
                }
                GeometryReader { geometry in
                    Image("invitationLogo")
                        .resizable()
                        .frame(width: 280, height: 387)
                        .position(x: geometry.size.width - 140, y: geometry.size.height - 160)
                }
                VStack(alignment: .center) {
                    Spacer()
                    
                    Text("당신을 초대합니다🎉")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.gray6)
                    
                    ZStack {
                        Image("invitation")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 320, height: 436)
                            .padding(.leading, 30)
                        
                        if isImageVisible {
                            VStack {
                                if let showDetail = viewModel.showDetail,
                                   let invitationImage = InvitationImage.from(rawValue: showDetail.invitationImage) {
                                    
                                    Image(invitationImage.imageName)
                                        .resizable()
                                        .frame(width: 260, height: 280)
                                    
                                    Text(showDetail.clubName)
                                        .font(.system(size: 20, weight: .semibold))
                                        .padding(.top, 10)
                                        .foregroundColor(.gray6)
                                    
                                }
                            }
                            .padding(.bottom, 30)
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
                                                .font(.system(size: 16, weight: .semibold))
                                        }
                                        
                                        Spacer()
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Divider()
                                        Text("기간")
                                            .font(.system(size: 16, weight: .bold))
                                            .padding(.top,10)
                                            .foregroundColor(.gray6)
                                        
                                        
                                        HStack {
                                            Text("우리 약속까지 ")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.gray6)
                                            
                                            Text(showDetail.dday)
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.sub3Color)
                                            
                                            Text("일 남았어요")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.gray6)
                                            
                                        }
                                        
                                        Text("인원")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.gray6)
                                        
                                        
                                        Text("\(showDetail.number)명")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.gray6)
                                        
                                        
                                        Text("시간 및 장소")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.gray6)
                                        
                                        
                                        Text(showDetail.time + "\n" + showDetail.place)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.gray6)
                                        
                                        
                                        Text("TO DO")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.gray6)
                                        
                                        
                                        VStack(alignment: .leading) {
                                            ForEach(showDetail.todo.split(separator: "\n"), id: \.self) { todo in
                                                Text("• \(todo)")
                                                    .foregroundColor(.gray6)
                                                
                                            }
                                        }
                                        .font(.system(size: 14, weight: .medium))
                                    }
                                }
                                .padding(30)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                                .frame(width: 320, height: 436)
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
                    
                    Spacer()
                    
                    Button(action: {
                        applyInvitation()
                    }) {
                        Text("참여하기")
                            .font(.headline)
                            .foregroundColor(.yellow)
                            .padding()
                            .frame(maxWidth: 320)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                            .padding(.bottom, 20)
                    }
                    .disabled(isInvitationApplied)
                    
                    NavigationLink(
                        destination: InviteFinalView(),
                        isActive: $isInvitationApplied,
                        label: { EmptyView() }
                    )
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
    }
}
