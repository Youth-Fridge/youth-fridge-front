//
//  MyActivityView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct MyActivityView: View {
    @State private var selectedTab : Int
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: MyPageViewModel
    @EnvironmentObject var tabSelectionViewModel: TabSelectionViewModel
    
    @StateObject private var myInvitationsViewModel = MyInvitationsViewModel()
    @StateObject private var myApplicationViewModel = MyApplicationViewModel()
    
    private let selectedTabColor = Color.main1Color
    private let unselectedTabColor = Color.gray1Color
    private let tabTextColorSelected = Color.white
    private let tabTextColorUnselected = Color.black
    
    init(selectedTab: Int = 0, viewModel: MyPageViewModel) {
        _selectedTab = State(initialValue: selectedTab)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .top) {
            ShadowNavigationBar()
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
        .onAppear {
            selectedTab = tabSelectionViewModel.selectedSubTab
            if selectedTab == 0 {
                myInvitationsViewModel.fetchActivities()
            } else {
                myApplicationViewModel.fetchActivities()
            }
        }
        .onChange(of: selectedTab) { newTab in
            if newTab == 0 {
                myInvitationsViewModel.fetchActivities()
            } else {
                myApplicationViewModel.fetchActivities()
            }
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
                    MyInvitationsView(viewModel: myInvitationsViewModel)
                } else {
                    ApplicationHistoryView(viewModel: myApplicationViewModel)
                }
            }
        }
        .scrollIndicators(.hidden)
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
                .font(selectedTab == tabIndex ? .pretendardSemiBold16 : .pretendardMedium16)
                .frame(width: 90, height: 20)
                .padding(8)
                .background(selectedTab == tabIndex ? selectedTabColor : unselectedTabColor)
                .foregroundColor(selectedTab == tabIndex ? tabTextColorSelected : tabTextColorUnselected)
                .cornerRadius(8)
        }
    }
}
