//
//  ComplainView.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/30/24.
//

import SwiftUI

struct ComplainView: View {
    @StateObject private var viewModel = ComplainViewModel()
    @State private var selectedCategories: Set<Int> = []
    @State private var showAlert = false
    @State private var showConfirmationAlert = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var tabSelectionViewModel: TabSelectionViewModel

    let invitationId: Int  // 신고할 초대장의 ID

    var body: some View {
        NavigationStack {
            ZStack {
                Color.sub2
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("신고하는 이유가 무엇인가요?")
                        .font(.pretendardBold24)
                        .multilineTextAlignment(.center)
                        .padding(.vertical,80)
                    VStack(spacing: 10) {
                        ForEach(viewModel.categories.indices, id: \.self) { index in
                            Button(action: {
                                if selectedCategories.contains(index) {
                                    selectedCategories.remove(index)
                                } else {
                                    selectedCategories.insert(index)
                                }
                            }) {
                                Text(viewModel.categories[index])
                                    .font(.pretendardMedium14)
                                    .foregroundColor(.gray6)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedCategories.contains(index) ? .main1Color : Color.clear, lineWidth: 3)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    Spacer()
                    
                    Button(action: {
                        if !selectedCategories.isEmpty {
                            viewModel.saveSelectedCategories(Array(selectedCategories), invitationId: invitationId)
                            showConfirmationAlert = true
                        } else {
                            showAlert = true
                        }
                    }) {
                        Text("신고하기")
                            .font(.pretendardBold20)
                            .foregroundColor(!selectedCategories.isEmpty ? Color.sub3Color : Color.black)
                            .padding()
                            .frame(width: 320, height: 60)
                            .background(!selectedCategories.isEmpty ? Color.white : Color.gray2)
                            .cornerRadius(8)
                    }
                    .padding(.bottom,50)
                    .disabled(selectedCategories.isEmpty)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("경고"),
                            message: Text("카테고리를 선택해주세요."),
                            dismissButton: .default(Text("확인"))
                        )
                    }
                    .alert(isPresented: $viewModel.showConfirmationAlert) {  
                        Alert(
                            title: Text("신고 완료"),
                            message: Text("24시간 이내 조치가 이루어집니다."),
                            dismissButton: .default(Text("확인")) {
                                tabSelectionViewModel.selectedTab = .home
                            }
                        )
                    }
                }
            }
            .onAppear {
                viewModel.loadCategories()
            }
            .navigationTitle("게시물 신고하기")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            })
        }
    }
}

#Preview {
    ComplainView(invitationId: 1)
}
