//
//  MyPageView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI

struct MyPageView: View {
    @ObservedObject var viewModel: MyPageViewModel
    @State private var showDeletePopup = false
    @State private var isNavigatingToMyActivty = false
    @State private var showLogOutDeletePopup = false
    @StateObject private var navigationManager = NavigationManager()
    @EnvironmentObject var tabSelectionViewModel: TabSelectionViewModel

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    welcomeMessage
                    profileView
                    activityList
                }
                .padding(.top, 1)
                
                ShadowNavigationBar()
                
                if showDeletePopup {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showDeletePopup = false
                            }
                        }
                    
                    PopUpView(
                        message: "청년냉장고를 탈퇴하시겠습니까?",
                        onClose: {
                            withAnimation {
                                showDeletePopup = false
                            }
                        },
                        onConfirm: {
                            withAnimation {
                                showDeletePopup = false
                                OnboardingAPI.shared.quitMember { result in
                                    switch result {
                                    case .success(let isSuccess):
                                        if isSuccess {
                                            UserDefaults.standard.removeObject(forKey: "nickname")
                                            UserDefaults.standard.removeObject(forKey: "profileImage")
                                            KeychainHandler.shared.accessToken = ""
                                            navigationManager.currentView = .loginIntro
                                        } else {
                                            print("Failed to quit member.")
                                        }
                                    case .failure(let error):
                                        
                                        print("Error quitting member: \(error.localizedDescription)")
                                    }
                                }
                            }
                        },
                        onCancel: {
                            withAnimation {
                                showDeletePopup = false
                            }
                        })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .zIndex(1)
                }
                
                if showLogOutDeletePopup {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showDeletePopup = false
                            }
                        }
                    
                    PopUpView(
                        message: "로그아웃 하시겠습니까?",
                        onClose: {
                            withAnimation {
                                showLogOutDeletePopup = false
                            }
                        },
                        onConfirm: {
                            withAnimation {
                                KeychainHandler.shared.accessToken = ""
                                showLogOutDeletePopup = false
                                navigationManager.currentView = .loginIntro
                            }
                        },
                        onCancel: {
                            withAnimation {
                                showLogOutDeletePopup = false
                            }
                        })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .zIndex(1)
                }
                NavigationLink(
                    destination: MyActivityView(viewModel: viewModel),
                    isActive: $isNavigatingToMyActivty,
                    label: { EmptyView() }
                )
                
                NavigationLink(
                    destination: LoginIntroView()
                        .navigationBarBackButtonHidden(true)
                        .toolbar(.hidden, for: .tabBar),
                    isActive: Binding(
                        get: { navigationManager.currentView == .loginIntro },
                        set: { newValue in
                            if !newValue {
                                navigationManager.currentView = nil
                            }
                        }
                    ),
                    label: { EmptyView() }
                )
            }
            .onAppear {
                if tabSelectionViewModel.shouldNavigateToMyActivity {
                    isNavigatingToMyActivty = true
                }
            }
            .navigationTitle("마이페이지")
            .navigationBarTitleDisplayMode(.inline)
            .environmentObject(navigationManager)
        }
    }
    
    var profileView: some View {
        HStack() {
            if let user = viewModel.myUser {
                Image(user.profilePicture)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.leading, 12)
                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        Text("\(user.name) 님")
                            .font(.pretendardSemiBold18)
                        
                        Spacer()
                    }
                    Text("초대 모임 예정일")
                        .font(.pretendardSemiBold14)
                        .foregroundColor(.main1Color)
                    Text(viewModel.launchDate != nil && viewModel.startTime != nil
                         ? "\(viewModel.launchDate!) \(viewModel.startTime!)"
                         : "예정된 초대 모임이 없습니다")
                    .font(.pretendardRegular12)
                    .foregroundColor(.gray6Color)
                }
                .padding(.leading, 15)
            } else {
                Text("Loading...")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.sub1)
    }
    
    var welcomeMessage: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let user = viewModel.myUser {
                Text("\(user.name) 님,")
                    .font(.pretendardBold24)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                    .padding(.leading, 30)
                
                Text("오늘도 건강한 식사하세요!")
                    .font(.pretendardMedium18)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 30)
            } else {
                Text("Loading...")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.sub1)
    }
    
    var activityList: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(activityItems, id: \.self) { item in
                if item == "내 활동" {
                    ActivityCell(title: item, subTitles: ["나의 초대장", "신청 내역"])
                        .onTapGesture {
                            isNavigatingToMyActivty = true
                        }
                        .contentShape(Rectangle())
                } else if item == "문의" {
                    // 문의 항목을 클릭하면 카카오 채널로 이동
                    Button(action: {
                        if let url = URL(string: "http://pf.kakao.com/_kxlxjyG") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        ActivityCell(title: item, subTitles: [])
                            .contentShape(Rectangle())
                    }
                    // TODO: - 추후 채널 ID로 바로 채팅 연결
    //                    .onTapGesture {
    //                        TalkApi.shared.chatChannel(channelPublicId: "YOUR_CHANNEL_ID") { error in
    //                            if let error = error {
    //                                print("Failed to open channel: \(error)")
    //                            } else {
    //                                print("chatChannel() success.")
    //                            }
    //                        }
    //                    }
                } else if item == "회원탈퇴" {
                    Button(action: {
                        showDeletePopup = true
                    }) {
                        ActivityCell(title: item, subTitles: nil)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .contentShape(Rectangle())
                } else if item == "로그아웃" {
                    Button(action: {
                        showLogOutDeletePopup = true
                    }) {
                        ActivityCell(title: item, subTitles: nil)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .contentShape(Rectangle())
                } else {
                    ActivityCell(title: item, subTitles: nil)
                        .contentShape(Rectangle())
                }
            }
        }
        .padding()
        .padding(.horizontal, 17)
        .padding(.trailing, 15)
    }
    let activityItems = ["내 활동", "문의", "회원탈퇴", "로그아웃"]
}

struct ActivityCell: View {
    var title: String
    var subTitles: [String]?
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.pretendardBold18)
                    .foregroundColor(.black)
                    .listSectionSeparator(.hidden)
                
                Spacer()
                
                Image("right-arrow")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.trailing, -18)
            }
            .padding(.vertical, 10)
            
            if let subTitles = subTitles {
                VStack(spacing: 0) {
                    ForEach(subTitles, id: \.self) { subTitle in
                        HStack {
                            Text(subTitle)
                                .font(.pretendardRegular14)
                                .allowsHitTesting(false)
                            
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        let services = Services()
        let container = DIContainer(services: services)
        MyPageView(viewModel: MyPageViewModel(container: container))
    }
}
