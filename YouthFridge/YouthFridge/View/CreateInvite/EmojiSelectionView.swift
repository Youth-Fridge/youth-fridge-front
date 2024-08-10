//
//  EmojiSelectionVIew.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/29/24.
//

import SwiftUI

struct EmojiSelectionView: View {
    let emojiImages = Emoji.allCases.map { $0.imageName }
    
    @Binding var selectedImage: String?
    @Binding var selectedEmojiNumber: Int
    @Binding var isShowing: Bool
    @State private var currentPage = 0
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Text("000님")
                    .font(.system(size: 18, weight: .semibold))
                Text("이모지를 선택해 주세요.")
                    .font(.system(size: 18, weight: .semibold))
                    .padding()
            }
            
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

                                    if let unwrappedSelectedImage = selectedImage,
                                       let selectedEmoji = Emoji.from(imageName: unwrappedSelectedImage) {
                                        let emojiNumber = selectedEmoji.rawValue
                                        selectedEmojiNumber = emojiNumber
                                        print("이모지 몇번 선택했냐능 ????? \(emojiNumber)")
                                    }
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
                .foregroundColor(.gray6)
                .cornerRadius(8)
                .padding()
                
                Button("저장") {
                    isShowing = false
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.yellow)
                .foregroundColor(.gray6)
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
