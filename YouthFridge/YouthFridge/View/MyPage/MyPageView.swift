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
            VStack(spacing: 20) {
                welcomeMessage
                profileView
            }
            .padding()
            .navigationTitle("마이페이지")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var profileView: some View {
        HStack {
            if let user = viewModel.myUser {
                Image(user.profilePicture)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 7) {
                    Text(user.name)
                        .font(.headline)
                }
            } else {
                Text("Loading...")
            }
        }
        .padding()
    }
    
    var welcomeMessage: some View {
        if let user = viewModel.myUser {
            Text("\(user.name) 님\n오늘도 건강한 식사하세요")
                .font(.title3)
                .multilineTextAlignment(.leading)
                .padding()
        } else {
            Text("Loading...")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
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
