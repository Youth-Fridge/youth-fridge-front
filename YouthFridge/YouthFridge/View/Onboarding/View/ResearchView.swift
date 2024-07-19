//
//  ResearchView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct ResearchView: View {
    @StateObject private var viewModel = ResearchViewModel()
    @State private var selectedCategory: Int? = nil
    @State private var navigateToNextView = false

    var body: some View {
        NavigationView {
            VStack {
                ProgressView(value: 0.5)
                    .progressViewStyle(CustomProgressViewStyle())
                    .padding()
                
                Text("나의 식생활이\n더 즐겁도록 추천해 드릴게요")
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 10)
                    .padding([.leading, .top], 30)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("관심있는 카테고리를 선택해주세요")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.leading)
                    .padding([.leading, .bottom], 30)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 25) {
                    ForEach(viewModel.categories.indices, id: \.self) { index in
                        Button(action: {
                            selectedCategory = index
                        }) {
                            Text(viewModel.categories[index])
                                .font(.system(size: 16))
                                .foregroundColor(selectedCategory == index ? .black : .black)
                                .padding()
                                .frame(maxWidth: .infinity,alignment: .leading)
                                .background(selectedCategory == index ? .research : Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(selectedCategory == index ? .main1Color : Color.gray2Color, lineWidth: 2)
                                )
                        }
                    }
                }
                .padding(.horizontal,30)
                
                Spacer()
                
                NavigationLink(destination: ProfileResearchView(), isActive: $navigateToNextView) {
                    Button(action: {
                        navigateToNextView = true // 버튼 클릭 시 다음 뷰로 이동하도록 설정
                    }) {
                        Text("다음")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.sub2Color)
                            .cornerRadius(8)
                    }
                    .padding(.bottom, 30)
                    .padding(.horizontal)
                }
            }
            .onAppear {
                viewModel.loadCategories()
            }
        }
    }
}

struct ResearchView_Previews: PreviewProvider {
    static var previews: some View {
        ResearchView()
    }
}
