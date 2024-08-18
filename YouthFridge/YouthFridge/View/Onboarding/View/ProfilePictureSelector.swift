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
    let profileImages = ["broccoli", "pea", "corn", "tomato", "branch", "pumpkin"]
    let bigProfileImages = ["bigBrocoli","bigPea","bigCorn","bigTomato","bigBranch","bigPumpkin"]
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
                .padding(.top,10)
                .padding(.bottom, 30)
            Spacer()
            Image(tempSelectedImage)
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
            TabView {
                ForEach(0..<2) { pageIndex in
                    HStack(spacing: 18) {
                        ForEach(0..<3) { imageIndex in
                            let index = pageIndex * 3 + imageIndex
                            if index < profileImages.count {
                                Image(profileImages[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(tempSelectedImage == bigProfileImages[index] ? Color.main1Color : Color.clear, lineWidth: 2))
                                    .onTapGesture {
                                        tempSelectedImage = bigProfileImages[index]
                                        saveSelectedImageIndex(index)
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
            HStack(spacing: 18) {
                Button(action: {
                    tempSelectedImage = "bigBrocoli"
                    saveSelectedImageIndex(profileImages.firstIndex(of: "broccoli") ?? 0)
                }) {
                    Text("지우기")
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .font(.system(size: 16,weight: .medium))
                        .background(Color.gray2Color)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(.leading, 30)
                }
                Button(action: {
                    selectedImage = tempSelectedImage
                    if let index = bigProfileImages.firstIndex(of: tempSelectedImage) {
                        saveSelectedImageIndex(index)
                    }
                    isShowing = false
                }) {
                    Text("저장")
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .font(.system(size: 16,weight: .medium))
                        .background(Color.sub2Color)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(.trailing, 30)
                }
            }
            
        }
        .frame(maxWidth: .infinity)
    }
    
    private func setupPageControlAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.gray
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray
    }
    
    private func saveSelectedImageIndex(_ index: Int) {
        let type = UserDefaults.standard.string(forKey: "loginType") ?? "unknown"
        let profileImageKey = type == "apple" ? "appleProfileImageNumber" : type == "kakao" ? "kakaoProfileImageNumber" : "profileImageNumber"
        UserDefaults.standard.setValue(index, forKey: profileImageKey)
        print("Saved image index: \(index)")
        
    }
}
