//
//  EmojiSelectionVIew.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/29/24.
//

import SwiftUI

struct EmojiSelectionView: View {
    let emojiImages = ["basket", "cooking", "delivery", "desert", "diet", "friends", "healthFood", "hobby", "reading", "recipe","homework","exercise"]
    @Binding var selectedImage: String?
    @Binding var isShowing: Bool
    @State private var currentPage = 0
    var body: some View {
        VStack {
            Text("000님")
            Text("이모지를 선택해 주세요.")
                .font(.system(size: 18,weight: .semibold))
                .padding()
            TabView(selection: $currentPage) {
                ForEach(0..<emojiImages.count/6) { pageIndex in
                    let startIndex = pageIndex * 6
                    let endIndex = min(startIndex + 5, emojiImages.count - 1)
                    let images = Array(emojiImages[startIndex...endIndex])
                    
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 20) {
                        ForEach(images, id: \.self) { imageName in
                            CircleView(imageName: imageName, isSelected: selectedImage == imageName)
                                .onTapGesture {
                                    selectedImage = imageName
                                }
                        }
                    }
                    .padding()
                }
            }
            .tabViewStyle(PageTabViewStyle())
            HStack {
                Button("지우기") {
                    selectedImage = nil
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding()
                
                Button("저장") {
                    // Handle the saving action
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.yellow)
                .cornerRadius(8)
                .padding()
            }
        }
    }
}
struct CircleView: View {
    let imageName: String
    var isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.1))
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.yellow : Color.clear, lineWidth: 2)
                )
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
    }
}
