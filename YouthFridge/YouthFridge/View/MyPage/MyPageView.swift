//
//  MyPageView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI

struct MyPageView: View {
    @StateObject var viewModel: MyPageViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        welcomeMessage
                        profileView
                        activityList
                    }
                }
                .padding(.top, 15)
                
                ShadowNavigationBar()
            }
            .navigationTitle("마이페이지")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Image(viewModel.myUser!.profilePicture)
                .resizable()
                .frame(width: 40, height: 40)
            )
        }
    }
    
    var profileView: some View {
        HStack() {
            if let user = viewModel.myUser {
                Image(user.profilePicture)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        Text("\(user.name) 님")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image("right-arrow")
                            .foregroundColor(.gray)
                    }
                    Text("초대 모임 예정일")
                        .font(.subheadline)
                        .foregroundColor(.main1Color)
                    Text("07월 30일 화요일 오후 7시")
                        .font(.caption)
                        .foregroundColor(.gray6Color)
                }
                .padding(.leading,20)
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
                    .padding(.top, 25)
                    .padding(.leading, 25)
                
                Text("오늘도 건강한 식사하세요!")
                    .font(.system(size: 18))
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 25)
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
                } else {
                    ActivityCell(title: item, subTitles: nil)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    let activityItems = ["내 활동", "문의", "회원탈퇴"]
}




struct ActivityCell: View {
    var title: String
    var subTitles: [String]?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .listSectionSeparator(.hidden)
            
            Spacer()
            
            Image("right-arrow")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 10)
        
        if let subTitles = subTitles {
            VStack(spacing: 0) {
                ForEach(subTitles, id: \.self) { subTitle in
                    HStack {
                        Text(subTitle)
                            .font(.system(size: 16))
                        
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .buttonStyle(PlainButtonStyle())
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
