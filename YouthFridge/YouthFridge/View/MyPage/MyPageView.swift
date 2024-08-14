//
//  MyPageView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI

struct MyPageView: View {
    @StateObject var viewModel: MyPageViewModel
    @State private var showDeletePopup = false
    @State private var navigateToMyActivity = false
    @State private var showLogOutDeletePopup = false
    @State private var navigateToLoginIntro = false
    var body: some View {
        NavigationView {
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
                                            KeychainHandler.shared.accessToken = ""
                                            navigateToLoginIntro = true
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
                                navigateToLoginIntro = true
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
                    isActive: $navigateToMyActivity,
                    label: { EmptyView() }
                )
                .navigationDestination(isPresented: $navigateToLoginIntro) {
                    LoginIntroView().navigationBarBackButtonHidden()
                }
            }
            .navigationTitle("마이페이지")
            .navigationBarTitleDisplayMode(.inline)
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
                            .font(.headline)
                        
                        Spacer()
                        
                        Image("right-arrow")
                            .foregroundColor(.gray)
                            .padding(.trailing, 12)
                            .onTapGesture {
                                // TODO: - 초대장 상세보기 API 연동
                                print("초대장 상세 보기 필요해 !!")
                            }
                    }
                    Text("초대 모임 예정일")
                        .font(.subheadline)
                        .foregroundColor(.main1Color)
                    Text(viewModel.launchDate != nil && viewModel.startTime != nil
                        ? "\(viewModel.launchDate!) \(viewModel.startTime!)"
                        : "예정된 초대 모임이 없습니다")
                        .font(.caption)
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
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .padding(.top, 30)
                    .padding(.leading, 30)
                
                Text("오늘도 건강한 식사하세요!")
                    .font(.system(size: 18))
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
        List {
            ForEach(activityItems, id: \.self) { item in
                if item == "내 활동" {
                    ActivityCell(title: item, subTitles: ["나의 초대장", "신청 내역", "스크랩"])
                        .onTapGesture {
                            navigateToMyActivity = true
                        }
                } else if item == "회원탈퇴" {
                    Button(action: {
                        showDeletePopup = true
                    }) {
                        ActivityCell(title: item, subTitles: nil)
                    }
                } else if item == "로그아웃" {
                    Button(action: {
                        showLogOutDeletePopup = true
                    }) {
                        ActivityCell(title: item, subTitles: nil)
                    }
                } else {
                    ActivityCell(title: item, subTitles: nil)
                }
            }
        }
        .listStyle(PlainListStyle())
        .padding(.horizontal, 12)
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
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .listSectionSeparator(.hidden)
                
                Spacer()
                
                Image("right-arrow")
            }
            .padding(.vertical, 10)
            
            if let subTitles = subTitles {
                VStack(spacing: 0) {
                    ForEach(subTitles, id: \.self) { subTitle in
                        HStack {
                            Text(subTitle)
                                .font(.system(size: 16))
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
