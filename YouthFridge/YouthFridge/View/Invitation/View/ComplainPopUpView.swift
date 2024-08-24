//
//  ComplainPopUpView.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/24/24.
//

import SwiftUI

struct ComplainPopUpView: View {
    var message: String
    var onConfirm: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
            }
            .padding([.top, .trailing], -7)
            
            Text(message)
                .font(.system(size: 16, weight: .semibold))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 16)
            
            Text("자세한 내용은 아래 버튼을 클릭해주세요")
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray3)
                .padding(.bottom, 7)
                .padding(.top, -15)
            
                Button(action: {
                    onConfirm()
                }) {
                    Text("문의처")
                        .font(.headline)
                        .foregroundColor(.gray6Color)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 32)
                        .frame(maxWidth: .infinity)
                        .background(Color.sub2Color)
                        .cornerRadius(6)
                }
                .frame(height: 35)
                .padding(.horizontal, 80)
                .padding(.bottom, 10)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 20)
        .frame(maxWidth: 310, minHeight: 160)
    }
}
