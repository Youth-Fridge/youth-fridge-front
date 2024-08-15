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
    @State private var tempSelectedImage: String? // 선택된 이미지 이름 임시 저장
    @State private var tempSelectedImageNumber: Int? // 선택된 이미지 번호 임시 저장

    var body: some View {
        VStack {
            Text("초대장 전체보기")
                .font(.system(size: 24, weight: .semibold))
                .padding(.top, 30)
                .padding(.bottom, 20)
            
            GridView(
                images: images,
                tempSelectedImage: $tempSelectedImage,
                tempSelectedImageNumber: $tempSelectedImageNumber
            )
            Button(action: {
                if let tempImage = tempSelectedImage, let tempNumber = tempSelectedImageNumber {
                    selectedImage = tempImage
                    selectedImageNumber = tempNumber
                }
                
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("선택완료")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(tempSelectedImage != nil ? Color.white : Color.gray6)
                    .padding()
                    .frame(maxWidth: 320)
                    .background(tempSelectedImage != nil ? Color.sub2 : Color.gray2)
                    .cornerRadius(8)
            }
            .disabled(tempSelectedImage == nil) // 선택되지 않으면 버튼 비활성화
        }
    }
}

struct GridView: View {
    let images: [InvitationImage]
    @Binding var tempSelectedImage: String?
    @Binding var tempSelectedImageNumber: Int?
    
    let columns = [
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(images, id: \.self) { image in
                    Image(image.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 140, height: 186)
                        .cornerRadius(4)
                        .clipped()
                        .onTapGesture {
                            tempSelectedImage = image.imageName
                            tempSelectedImageNumber = image.rawValue
                            print("초대장 이미지 뭐 선택함 ?!! \(image.rawValue)")
                        }
                        .border(Color.main1Color, width: tempSelectedImage == image.imageName ? 4 : 0)
                        .cornerRadius(4)
                }
            }
            .padding(.horizontal, 30)
        }
    }
}
