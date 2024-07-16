//
//  ResearchView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct CustomProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .accentColor(Color.sub2Color)
    }
}
struct ResearchView: View {
    @StateObject private var viewModel = ResearchViewModel()
    
    var body: some View {
        VStack {
            ProgressView(value: 0.5)
                .progressViewStyle(CustomProgressViewStyle())
                .padding()
            
            Text("나의 식생활이\n더 즐겁도록 추천해 드릴게요")
                .font(.system(size: 24,weight: .bold))
                .multilineTextAlignment(.leading)
            Text("관심있는 카테고리를 선택해주세요")
                .font(.headline)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            List(viewModel.categories, id: \.self) { category in
                Text(category)
                    .padding()
            }
            .listStyle(PlainListStyle())
            
            Button(action: {
                
            }) {
                Text("다음")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.sub2Color)
                                    .cornerRadius(8)
                            }
            .padding()
            }
            
        
        .onAppear {
            
        }
    }
}

// Preview 정의
struct ResearchView_Previews: PreviewProvider {
    static var previews: some View {
        ResearchView()
    }
}
