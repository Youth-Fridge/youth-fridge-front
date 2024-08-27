//
//  EmojiSelectionVIew.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/29/24.
//

import SwiftUI

struct EmojiSelectionView: View {
    let emojiImages = Emoji.allCases.map { $0.imageName }
    
    @Binding var nickname: String?
    @Binding var selectedImage: String?
    @Binding var selectedEmojiNumber: Int
    @Binding var isShowing: Bool
    @State private var currentPage = 0
    
    private var imageName: String?
    
    init(nickname: Binding<String?>, selectedImage: Binding<String?>, selectedEmojiNumber: Binding<Int>, isShowing: Binding<Bool>) {
        self._nickname = nickname
        self._selectedImage = selectedImage
        self._selectedEmojiNumber = selectedEmojiNumber
        self._isShowing = isShowing
    
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.gray3
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray2
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                if let userName = nickname {
                    Text("\(userName)님\n이모지를 선택해 주세요")
                        .font(.pretendardSemiBold24)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.top, 30)
            
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
                    .padding(.top, -35)
                    .padding(.horizontal, 20)
                    .onAppear {
                        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.gray3
                        UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray2
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            HStack(spacing: 20) {
                Button("지우기") {
                    selectedImage = nil
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.gray.opacity(0.2))
                .font(.pretendardMedium16)
                .foregroundColor(Color.gray6)
                .cornerRadius(4)
                
                Button("저장") {
                    isShowing = false
                    if let unwrappedSelectedImage = selectedImage,
                       let selectedEmoji = Emoji.from(imageName: unwrappedSelectedImage) {
                        selectedEmojiNumber = selectedEmoji.rawValue
                        print("이모지 몇번 선택했어 ????? \(selectedEmoji.rawValue)")
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.sub2)
                .font(.pretendardMedium16)
                .foregroundColor(Color.gray6)
                .cornerRadius(4)
            }
            .padding(.horizontal, 30)
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
                .frame(width: 80, height: 80)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.yellow : Color.clear, lineWidth: 4)
                )
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
        }
    }
}
