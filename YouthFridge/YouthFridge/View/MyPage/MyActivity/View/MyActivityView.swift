//
//  MyActivityView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct MyActivityView: View {
    @State private var selectedTab = 0
    
    @StateObject var viewModel: MyPageViewModel
    
    private let selectedTabColor = Color.main1Color
    private let unselectedTabColor = Color.gray1Color
    private let tabTextColorSelected = Color.white
    private let tabTextColorUnselected = Color.black
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ShadowNavigationBar()
                
                VStack(spacing: 0) {
                    tabButtons
                    contentView
                    if selectedTab == 0 {
                        plusButton
                    }
                    
                }
                .padding(.top, 45)
                .padding(.horizontal, 10)
            }
            .navigationTitle("내 활동")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Image(viewModel.myUser!.profilePicture)
                .resizable()
                .frame(width: 40, height: 40)
            )
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
        HStack {
            Spacer()
            Button(action: {
                print("초대장 추가 버튼")
            }) {
                Image("plus")
                    .resizable()
                    .frame(width: 80, height: 80)
            }
            .padding(.trailing, 20)
        }
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

struct ApplicationHistoryView: View {
    var body: some View {
        Text("신청 내역 내용")
            .padding()
    }
}

struct MyActivityView_Previews: PreviewProvider {
    static var previews: some View {
        let services = Services()
        let container = DIContainer(services: services)
        MyActivityView(viewModel: MyPageViewModel(container: container))
    }
}


