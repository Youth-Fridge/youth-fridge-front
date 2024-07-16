//
//  MyActivityView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct MyActivityView: View {
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer().frame(height: 15)
                HStack(spacing: 16) {
                    Button(action: {
                        selectedTab = 0
                    }) {
                        Text("나의 초대장")
                            .font(.system(size: 16,weight: .bold))
                            .frame(width: 90, height: 5)
                            .padding()
                            .background(selectedTab == 0 ? .main1Color : Color.gray1Color)
                            .foregroundColor(selectedTab == 0 ? .white : .black)
                            .cornerRadius(8)
                    }
                    Button(action: {
                        selectedTab = 1
                    }) {
                        Text("신청내역")
                            .font(.system(size: 16,weight: .bold))
                            .frame(width: 90, height: 5)
                            .padding()
                            .background(selectedTab == 1 ? .main1Color : Color.gray1Color)
                            .foregroundColor(selectedTab == 1 ? .white : .black)
                            .cornerRadius(8)
                    }
                    Spacer()
                }
                .padding(.horizontal)

                if selectedTab == 0 {
                    MyInvitationsView()
                } else {
                    ApplicationHistoryView()
                }
                
                Spacer()
            }
            .navigationTitle("내 활동")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(
                VStack {
                    Color.black.opacity(0.1)
                        .frame(height: 4)
                        .blur(radius: 3)
                        .offset(y:-10)
                    Spacer()
                }
            
            )
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
        MyActivityView()
    }
}


