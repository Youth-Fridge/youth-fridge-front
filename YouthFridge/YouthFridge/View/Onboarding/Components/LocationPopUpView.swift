//
//  LocationPopUpView.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/18/24.
//

import SwiftUI

struct LocationPopUpView: View {
    var message: String
    var onClose: () -> Void
    var onConfirm: () -> Void
    
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
                .font(.system(size: 16, weight: .semibold))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 16)
            
                Button(action: {
                    onConfirm()
                }) {
                    Text("확인 완료")
                        .font(.headline)
                        .foregroundColor(.gray6Color)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 32)
                        .frame(maxWidth: .infinity)
                        .background(Color.sub2Color)
                        .cornerRadius(6)
                }
                .frame(maxWidth: .infinity)
            
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 20)
        .frame(maxWidth: 310, minHeight: 160)
    }
}
