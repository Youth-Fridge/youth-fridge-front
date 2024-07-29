//
//  CancelPopUpView.swift
//  YouthFridge
//
//  Created by 임수진 on 7/29/24.
//

import SwiftUI

struct CancelPopUpView: View {
    var message: String
    var subMessage: String
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
                .padding(.bottom, -10)
            
            Text(subMessage)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(Color.gray6)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 20) {
                Button(action: {
                    onConfirm()
                }) {
                    Text("미참석")
                        .font(.headline)
                        .foregroundColor(.gray6Color)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 32)
                        .frame(maxWidth: .infinity)
                        .background(Color.sub2Color)
                        .cornerRadius(6)
                }
                .frame(width: 110, height: 35)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 20)
        .frame(maxWidth: 320, minHeight: 170)
    }
}
