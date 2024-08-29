//
//  StepCardView.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/29/24.
//

import SwiftUI

struct StepCardView: View {
    var viewModel : StepCardViewModel
    var body: some View {
        ZStack {
            
            VStack {
                Text(viewModel.number)
                    .font(.pretendardExtraBold52)
                    .foregroundColor(.white)
                Text(viewModel.title)
                    .font(.pretendardBold16)
                    .foregroundColor(.white)
                    .frame(height: 80)
                    .padding(.top,-40)
                    .multilineTextAlignment(.center)
                VStack {
                    Text(viewModel.subtitle)
                        .font(.pretendardMedium10)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                    
                    Text(viewModel.subtitle2)
                        .font(.pretendardMedium10)
                        .foregroundColor(.white)
                }
                .padding(.top,10)
                
            }
            
        }
        .frame(maxWidth: 100)
        .frame(height: 200)
        .padding()
        .background(viewModel.backgroundColor)
        .cornerRadius(10)
        
        }
    }


//#Preview {
//    StepCardView(viewModel: StepCardViewModel(number: "1", title: "생활밥서", subtitle: "밥심 챙기자", subtitle2: "안서동 소모임"))
//}
