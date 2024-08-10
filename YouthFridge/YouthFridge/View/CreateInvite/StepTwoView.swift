//
//  StepTwoView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/29/24.
//

import SwiftUI

struct StepTwoView: View {
    @ObservedObject var viewModel: CreateInviteViewModel
    @State private var selectedImage: String = "invitationImage3"
    @State private var showModal: Bool = false
    var body: some View {
        VStack {
            Image(selectedImage)
                .resizable()
                .frame(width: 324,height: 384)
                .padding(.top,20)
            HStack(spacing: 10) {
                ForEach(["invitationImage", "invitationImage2", "invitationImage4", "invitationImage5", "invitationImage6"], id: \.self) { imageName in
                    if imageName == "invitationImage6" {
                        ZStack {
                            Image(imageName)
                                .resizable()
                                .frame(width: 60, height: 80)
                                .background(Color.black)
                                .opacity(0.8)
                            Text("더보기")
                                .foregroundColor(.white)
                                .bold()
                        }
                        .onTapGesture {
                            showModal = true
                        }
                    } else {
                        Image(imageName)
                            .resizable()
                            .frame(width: 60,height: 80)
                            .onTapGesture {
                                selectedImage = imageName
                            }
                    }
                    
                }

            }
            NavigationLink(destination: MainTabView().navigationBarBackButtonHidden()) {
                Text("초대장 완성하기")
                    .font(.system(size: 16,weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 320)
                    .background(Color.yellow)
                    .cornerRadius(8)
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showModal) {
            ImageGridView(selectedImage: $selectedImage, selectedImageNumber: $viewModel.imageNumber)

        }
    }
}
