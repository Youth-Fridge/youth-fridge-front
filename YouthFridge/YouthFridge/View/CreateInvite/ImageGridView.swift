//
//  ImageGridView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/29/24.
//

import SwiftUI

struct ImageGridView: View {
    @Binding var selectedImage: String
    @Binding var selectedImageNumber: Int
    @Environment(\.presentationMode) var presentationMode
    
    let images = InvitationImage.allCases

    var body: some View {
        VStack {
            Text("초대장 전체보기")
                .font(.system(size: 24, weight: .semibold))
                .padding()
            
            GridView(images: images, selectedImage: $selectedImage, selectedImageNumber: $selectedImageNumber)
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("선택완료")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 320)
                    .background(Color.yellow)
                    .cornerRadius(8)
            }
        }
    }
}

struct GridView: View {
    let images: [InvitationImage]
    @Binding var selectedImage: String
    @Binding var selectedImageNumber: Int
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(images, id: \.self) { image in
                    Image(image.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 140, height: 186)
                        .clipped()
                        .onTapGesture {
                            selectedImage = image.imageName
                            selectedImageNumber = image.rawValue
                            print("초대장 이미지 뭐 선택함 ?!! \(image.rawValue)")
                        }
                        .border(Color.main1Color, width: selectedImage == image.imageName ? 4 : 0)
                }
            }
            .padding()
        }
    }
}
