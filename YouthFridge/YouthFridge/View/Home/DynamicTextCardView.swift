//
//  DynamicTextCardView.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/7/24.
//

import Foundation
import SwiftUI

struct DynamicTextCardView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var tabSelectionViewModel: TabSelectionViewModel
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.92)
                .cornerRadius(10)
            
            if viewModel.daysRemaining == 0 {
                Button(action: {
                    tabSelectionViewModel.selectedTab = .mypage
                    tabSelectionViewModel.selectedSubTab = 1
                    tabSelectionViewModel.shouldNavigateToMyActivity = true
                }) {
                    VStack(alignment: .leading) {
                        Text("우리 약속의")
                            .font(.pretendardSemiBold16)
                            .padding(.leading, 4)
                        
                        HStack(spacing: 3) {
                            ForEach(Array(String("D-DAY")), id: \.self) { char in
                                Text(String(char))
                                    .font(.pretendardBold32)
                                    .foregroundColor(Color.sub2Color)
                                    .frame(width: 32, height: 38)
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.gray2Color, lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
            } else if viewModel.daysRemaining == -1 {
                Button(action: {
                    tabSelectionViewModel.selectedTab = .mypage
                    tabSelectionViewModel.selectedSubTab = 1
                    tabSelectionViewModel.shouldNavigateToMyActivity = true
                }) {
                    VStack(alignment: .leading) {
                        Text("우리 약속까지")
                            .font(.pretendardSemiBold16)
                        
                        HStack(spacing: 5) {
                            ForEach(Array(String(format: "00")), id: \.self) { char in
                                Text(String(char))
                                    .font(.pretendardBold40)
                                    .foregroundColor(Color.sub2Color)
                                    .frame(width: 40, height: 48)
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.gray2Color, lineWidth: 1)
                                    )
                            }
                            Text("일 남았어요")
                                .font(.pretendardSemiBold16)
                                .padding(.bottom, -30)
                            
                        }
                    }
                }
            } else {
                Button(action: {
                    tabSelectionViewModel.selectedTab = .mypage
                    tabSelectionViewModel.selectedSubTab = 1
                    tabSelectionViewModel.shouldNavigateToMyActivity = true
                }) {
                    VStack(alignment: .leading) {
                        Text("우리 약속까지")
                            .font(.pretendardSemiBold16)
                        
                        HStack(spacing: 5) {
                            ForEach(Array(String(format: "%02d", viewModel.daysRemaining)), id: \.self) { char in
                                Text(String(char))
                                    .font(.pretendardBold40)
                                    .foregroundColor(Color.sub2Color)
                                    .frame(width: 40, height: 48)
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.gray2Color, lineWidth: 1)
                                    )
                            }
                            Text("일 남았어요")
                                .font(.pretendardSemiBold16)
                                .padding(.bottom, -30)
                            
                        }
                    }
                    
                }
            }
        }
        .cornerRadius(10)
        .frame(width: 190,height: 120)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0) // 그림자 추가
    }
}
