//
//  MyActivityView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct MyActivityView: View {
    @State private var selectedTab = 0
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: MyPageViewModel
    @StateObject var profileViewModel: SmallClassViewModel
    private let selectedTabColor = Color.main1Color
    private let unselectedTabColor = Color.gray1Color
    private let tabTextColorSelected = Color.white
    private let tabTextColorUnselected = Color.black
    init(selectedTab: Int = 0, viewModel: MyPageViewModel, profileViewModel: SmallClassViewModel) {
        _selectedTab = State(initialValue: selectedTab)
        _viewModel = StateObject(wrappedValue: viewModel)
        _profileViewModel = StateObject(wrappedValue: profileViewModel)
    }

    var body: some View {
            ZStack(alignment: .top) {
                    VStack(spacing: 0) {
                        tabButtons
                        ZStack {
                            contentView
                            VStack {
                                Spacer()
                                if selectedTab == 0 {
                                    plusButton
                                        .padding(.bottom, 20)
                                }
                            }
                        }
                    }
                
                .padding(.top, 30)
                .padding(.horizontal, 10)
            }
            .navigationTitle("내 활동")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(.visible, for: .tabBar)
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
                    if let profileImageUrl = profileViewModel.profileImageUrl {
                        if let profile = ProfileImage.from(rawValue: profileImageUrl) {
                            let profileImage = profile.imageName
                            Image(profileImage)
                                .resizable()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                        }
                        
                    }
                }
            }
            .onAppear {
                profileViewModel.fetchProfileImage()
            }
        
    }
    
    private var tabButtons: some View {
        HStack(spacing: 16) {
            tabButton(title: "나의 초대장", tabIndex: 0)
            tabButton(title: "신청 내역", tabIndex: 1)
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var contentView: some View {
        ScrollView {
            Group {
                if selectedTab == 0 {
                    MyInvitationsView()
                } else {
                    ApplicationHistoryView()
                }
            }
        }
    }
    
    private var plusButton: some View {
        NavigationLink(destination: CreateInviteView()) {
            HStack {
                Spacer()
                Image("plus")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .contentShape(Rectangle())
            }
            .padding(.trailing, 15)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func tabButton(title: String, tabIndex: Int) -> some View {
        Button(action: {
            selectedTab = tabIndex
        }) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 90, height: 20)
                .padding(8)
                .background(selectedTab == tabIndex ? selectedTabColor : unselectedTabColor)
                .foregroundColor(selectedTab == tabIndex ? tabTextColorSelected : tabTextColorUnselected)
                .cornerRadius(8)
        }
    }
}
