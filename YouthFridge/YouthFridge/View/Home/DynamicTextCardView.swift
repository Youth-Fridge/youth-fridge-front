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
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.92)
                .cornerRadius(10)
            
            // TODO: - 소모임 날짜 당일일 경우 처리하기
            if viewModel.daysRemaining == 0 {
                VStack(alignment: .leading) {
                    Text("우리 약속이")
                        .font(.system(size: 16, weight: .semibold))
                    
                    HStack {
                        ForEach(Array(String("D-DAY")), id: \.self) { char in
                            Text(String(char))
                                .font(.system(size: 30, weight: .bold))
                                .bold()
                                .foregroundColor(Color.sub2Color)
                                .frame(width: 28, height: 36)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray2Color, lineWidth: 1)
                                )
                        }
                    }
                    
                    Text("로 다가왔어요")
                        .font(.system(size: 16, weight: .semibold))
                }
            } else {
                VStack(alignment: .leading) {
                    Text("우리 약속까지")
                        .font(.system(size: 16,weight: .semibold))
                    HStack {
                        ForEach(Array(String(format: "%02d", viewModel.daysRemaining)), id: \.self) { char in
                            Text(String(char))
                                .font(.system(size: 40,weight: .bold))
                                .bold()
                                .foregroundColor(Color.sub2Color)
                                .frame(width: 40, height: 48)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray2Color, lineWidth: 1)
                                )
                        }
                        Text("일 남았어요")
                            .font(.system(size: 16,weight: .semibold))
                            .padding(.bottom, -30)
                        
                    }
                }
            }
        }
        .cornerRadius(10)
        .frame(width: 190,height: 120)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0) // 그림자 추가
    }
}
