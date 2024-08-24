//
//  StepTwoView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/29/24.
//

import SwiftUI

struct StepTwoView: View {
    @ObservedObject var viewModel: CreateInviteViewModel
    @State private var selectedImage: String = "invitationImage2"
    @State private var navigateToMainTabView = false
    @State private var showModal: Bool = false
    
    var body: some View {
        VStack {
            Image(selectedImage)
                .resizable()
                .frame(height: 384)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(.horizontal, 30)
                .padding(.top, 20)
                .padding(.bottom, 12)
            
            HStack(spacing: 5) {
                ForEach(["invitationImage0", "invitationImage1", "invitationImage3", "invitationImage4", "invitationImage5"], id: \.self) { imageName in
                    Group {
                        if imageName == "invitationImage5" {
                            ZStack {
                                Image(imageName)
                                    .resizable()
                                    .frame(maxWidth: 63)
                                    .frame(height: 80)
                                    .cornerRadius(4)
                                
                                Color.black
                                    .frame(maxWidth: 63)
                                    .frame(height: 80)
                                    .opacity(0.5)
                                    .cornerRadius(4)
                                
                                Text("더보기")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .bold()
                            }
                            .onTapGesture {
                                showModal = true
                            }
                        } else {
                            Image(imageName)
                                .resizable()
                                .frame(maxWidth: 63)
                                .frame(height: 80)
                                .cornerRadius(4)
                                .onTapGesture {
                                    selectedImage = imageName
                                    
                                    if let selectedImageEnum = InvitationImage.from(imageName: imageName) {
                                        let imageNumber = selectedImageEnum.rawValue
                                        viewModel.imageNumber = imageNumber
                                        print("초대장 이미지 뭐 선택함 ?!! \(imageNumber)")
                                    }
                                }
                        }
                    }
                }
            }
            
            Button(action: {
                viewModel.createInvitation()
                navigateToMainTabView = true
            }) {
                Text("초대장 완성하기")
                    .font(.system(size: 16,weight: .bold))
                    .foregroundColor(viewModel.isFormComplete ? Color.white : Color.gray6)
                    .padding()
                    .frame(maxWidth: 335)
                    .background(viewModel.isFormComplete ? Color.sub2 : Color.gray2)
                    .cornerRadius(8)
            }
            .disabled(!viewModel.isFormComplete)
            .padding(.top, 15)
            
            NavigationLink(
                destination: MainTabView().navigationBarBackButtonHidden(true),
                isActive: $navigateToMainTabView
            ) {
                EmptyView()
            }
        }
        .sheet(isPresented: $showModal) {
            ImageGridView(selectedImage: $selectedImage, selectedImageNumber: $viewModel.imageNumber)

        }
    }
}
