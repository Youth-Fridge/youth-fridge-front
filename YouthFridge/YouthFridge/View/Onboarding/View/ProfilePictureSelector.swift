//
//  ProfilePictureSelector.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/25/24.
//

import SwiftUI

struct ProfilePictureSelector: View {
    @Binding var selectedImage: String
    @Binding var isShowing: Bool
    let profileImages = ["broccoli", "branch", "corn", "pea", "pumpkin", "tomato"]
    @State private var tempSelectedImage: String
    
    init(selectedImage: Binding<String>, isShowing: Binding<Bool>) {
        self._selectedImage = selectedImage
        self._isShowing = isShowing
        _tempSelectedImage = State(initialValue: selectedImage.wrappedValue)
    }
    var body: some View {
        VStack {
            Spacer()
            Text("프로필 이미지를 꾸며보세요")
                .font(.system(size: 24, weight: .semibold))
                .padding(.bottom, 30)
            
            Image(tempSelectedImage)
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
            TabView {
                ForEach(0..<2) { pageIndex in
                    HStack {
                        ForEach(0..<3) { imageIndex in
                            let index = pageIndex * 3 + imageIndex
                            if index < profileImages.count {
                                Image(profileImages[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(selectedImage == profileImages[index] ? Color.blue : Color.clear, lineWidth: 2))
                                    .onTapGesture {
                                        tempSelectedImage = profileImages[index]
                                    }
                            }
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: 110)
            .onAppear {
                setupPageControlAppearance()
            }
            Spacer()
            HStack(spacing: 0) {
                Button(action: {
                    tempSelectedImage = "profileImage1"
                }) {
                    Text("지우기")
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(Color.gray2Color)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                Button(action: {
                    selectedImage = tempSelectedImage
                    isShowing = false
                }) {
                    Text("저장")
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(Color.sub2Color)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal,30)
    }
    
    private func setupPageControlAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.gray
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray
    }
}
