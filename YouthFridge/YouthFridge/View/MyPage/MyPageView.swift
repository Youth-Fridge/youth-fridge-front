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
            VStack(spacing: 0) {
                welcomeMessage
                profileView
                activityList
            }
            .padding()
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
                VStack(alignment: .leading, spacing: 7) {
                    Text("\(user.name)님")
                        .font(.headline)
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
        VStack(alignment: .leading, spacing: 8) {
            if let user = viewModel.myUser {
                Text("\(user.name)님,")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                
                Text("오늘도 건강한 식사하세요!")
                    .font(.system(size: 18))
                    .multilineTextAlignment(.leading)
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
                    ActivityCell(title: item)
                }
            }
            .listStyle(PlainListStyle())
        }
        
        let activityItems = ["내 활동", "문의", "회원탈퇴"]
    }

struct ActivityCell: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18,weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
        }
        .padding(.vertical, 10)
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        let services = Services()
        let container = DIContainer(services: services)
        MyPageView(viewModel: MyPageViewModel(container: container))
    }
}
