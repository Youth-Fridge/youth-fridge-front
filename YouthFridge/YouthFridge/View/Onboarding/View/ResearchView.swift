//
//  ResearchView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct ResearchView: View {
    @StateObject private var viewModel = ResearchViewModel()
    @State private var selectedCategories: Set<Int> = []
    @State private var showAlert = false
    @State private var navigateToNextView = false
    
    var body: some View {
            VStack {
                ProgressView(value: 0.5)
                    .progressViewStyle(CustomProgressViewStyle())
                    .padding()
                
                Text("나의 식생활이\n더 즐겁도록 추천해 드릴게요")
                    .font(.pretendardBold24)
                    .foregroundColor(.gray6)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 10)
                    .padding([.leading, .top], 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("관심있는 카테고리를 선택해주세요")
                    .font(.pretendardRegular14)
                    .multilineTextAlignment(.leading)
                    .padding([.leading, .bottom], 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 25) {
                    ForEach(viewModel.categories.indices, id: \.self) { index in
                        Button(action: {
                            if selectedCategories.contains(index) {
                                selectedCategories.remove(index)
                            } else {
                                selectedCategories.insert(index)
                            }
                        }) {
                            Text(viewModel.categories[index])
                                .font(.pretendardMedium16)
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(selectedCategories.contains(index) ? .research : Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(selectedCategories.contains(index) ? .main1Color : Color.gray2Color, lineWidth: 2)
                                )
                        }
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                Button(action: {
                    if !selectedCategories.isEmpty {
                        viewModel.saveSelectedCategories(Array(selectedCategories))
                        navigateToNextView = true
                    } else {
                        showAlert = true
                    }
                }) {
                    Text("다음")
                        .font(.pretendardBold20)
                        .foregroundColor(!selectedCategories.isEmpty ? Color.white : Color.black)
                        .padding()
                        .frame(width: 320, height: 60)
                        .background(!selectedCategories.isEmpty ? Color.sub2Color : Color.gray2)
                        .cornerRadius(8)
                }
                .disabled(selectedCategories.isEmpty)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("경고"),
                        message: Text("카테고리를 선택해주세요."),
                        dismissButton: .default(Text("확인"))
                    )
                }
                NavigationLink(destination: ProfileResearchView().navigationBarBackButtonHidden(), isActive: $navigateToNextView) {
                    EmptyView()
                }
            }
            .onAppear {
                viewModel.loadCategories()
            }
            .navigationBarHidden(true)
        
    }
}

//struct ResearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResearchView()
//    }
//}

