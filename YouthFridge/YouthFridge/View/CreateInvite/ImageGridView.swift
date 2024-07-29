//
//  ImageGridView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/29/24.
//

import SwiftUI

struct ImageGridView: View {
    @Binding var selectedImage: String
    let images = ["invitationImage", "invitationImage2", "invitationImage3", "invitationImage4", "invitationImage5", "invitationImage6"]
    
    var body: some View {
        VStack {
            Text("초대장 전체보기")
                .font(.system(size: 24, weight: .semibold))
                .padding()
            
            GridView(images: images, selectedImage: $selectedImage)
            NavigationLink(destination: MainTabView().navigationBarBackButtonHidden()) {
                Text("선택완료")
                    .font(.system(size: 16,weight: .bold))
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
    let images: [String]
    @Binding var selectedImage: String
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(images, id: \.self) { imageName in
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 140, height: 186)
                        .clipped()
                        .onTapGesture {
                            selectedImage = imageName
                        }
                        .border(Color.main1Color, width: selectedImage == imageName ? 4 : 0)
                }
            }
            .padding()
        }
    }
}
