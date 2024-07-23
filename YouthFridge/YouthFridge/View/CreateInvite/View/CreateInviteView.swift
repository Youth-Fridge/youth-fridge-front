//
//  CreateInviteView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/23/24.
// 초대장 작성

import SwiftUI

struct CreateInviteView: View {
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            VStack() {
                HStack(spacing: 16) {
                    Button(action: {
                        selectedTab = 0
                    }) {
                        Text("STEP1")
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
                        Text("STEP2")
                            .font(.system(size: 16,weight: .bold))
                            .frame(width: 90, height: 5)
                            .padding()
                            .background(selectedTab == 1 ? .main1Color : Color.gray1Color)
                            .foregroundColor(selectedTab == 1 ? .white : .black)
                            .cornerRadius(8)
                    }
                }
                Spacer()
            }
            .navigationTitle("초대장 작성")
            .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image("Ellipse")
                            .resizable()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                    }
                }
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

#Preview {
    CreateInviteView()
}
