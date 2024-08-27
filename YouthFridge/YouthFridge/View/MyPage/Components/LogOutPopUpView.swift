//
//  LogOutPopUpView.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/8/24.
//

import SwiftUI

struct LogOutPopUpView: View {
    var message: String
    var onClose: () -> Void
    var onConfirm: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                
                Button(action: {
                    onClose()
                }) {
                    Image("cancel")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .padding([.top, .trailing], -7)
            
            Text(message)
                .font(.pretendardSemiBold16)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 16)
            
            HStack(spacing: 20) {
                Button(action: {
                    onConfirm()
                }) {
                    Text("예")
                        .font(.pretendardSemiBold16)
                        .foregroundColor(.gray6Color)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 32)
                        .frame(maxWidth: .infinity)
                        .background(Color.sub2Color)
                        .cornerRadius(6)
                }
                .frame(width: 78, height: 50)
                
                Button(action: {
                    onCancel()
                }) {
                    Text("아니오")
                        .font(.pretendardMedium16)
                        .foregroundColor(.gray6Color)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 32)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray1Color)
                        .cornerRadius(6)
                        .fixedSize()
                }
                .frame(width: 90, height: 50)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 20)
        .frame(maxWidth: 310, minHeight: 160)
    }
}

