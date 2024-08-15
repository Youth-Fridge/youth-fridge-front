//
//  ProfileResearchView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/17/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct ProfileResearchView: View {
    @StateObject private var viewModel = ProfileResearchViewModel()
    @State private var navigateToNextView = false 
    var body: some View {
        NavigationView {
            VStack {
                ProgressView(value: 1)
                    .progressViewStyle(CustomProgressViewStyle())
                    .padding()
                Text("프로필 설정")
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                VStack {
                    Image(viewModel.selectedProfileImage)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                    Button(action: {
                        viewModel.isShowingProfileSelector.toggle()
                    }) {
                        Image("onboardingCamera")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    .padding(.top, -45)
                    .padding(.leading, 70)
                }
                Spacer()
                    .frame(height: 25)
                HStack(spacing: 0) {
                    Text("닉네임")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(viewModel.nicknameMessage)
                        .font(.system(size: 12))
                        .foregroundColor(.main1Color)
                }
                .padding(.horizontal)

                HStack {
                    TextField("6글자 이내", text: $viewModel.nickname)
                        .padding(.leading, 10)
                        .font(.system(size: 12))
                    Button(action: {
                        viewModel.checkNickname()
                    }) {
                        Text("중복 확인")
                            .font(.system(size: 12))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.main1Color)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .padding(10)
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.main1Color, lineWidth: 1)
                )
                .padding(.horizontal)

                .sheet(isPresented: $viewModel.isShowingProfileSelector) {
                    ProfilePictureSelector(selectedImage: $viewModel.selectedProfileImage, isShowing: $viewModel.isShowingProfileSelector)
                        .presentationDetents([.medium, .large])
                }
                .animation(.easeInOut, value: viewModel.isShowingProfileSelector)
                Spacer()
                    .frame(height: 30)
                Text("한 줄 소개")
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                TextField("15글자 이내 *ex: 365일 식단 조절러", text: $viewModel.introduceMe)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 12))
                    .padding(.horizontal)
                Spacer()
                    .frame(height: 30)
                HStack {
                    Text("우리 동네 인증하기")
                        .font(.system(size: 16, weight: .bold))
                        .frame(alignment: .leading)
                    NavigationLink(destination: MapDetailView(onCertification: { city, district in
                        viewModel.userCity = city
                        viewModel.userDistrict = district
                    })) {
                        Image("locationImage")
                            .resizable()
                            .frame(width: 16, height: 22)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                if !viewModel.userCity.isEmpty && !viewModel.userDistrict.isEmpty {
                    Button(action: {
                        // 버튼 클릭 시 동작 추가
                    }) {
                        HStack {
                            Image("locationImage")
                                .resizable()
                                .frame(width: 16, height: 22)
                            VStack(alignment: .leading) {
                                Text("\(viewModel.userCity)\(viewModel.userDistrict)")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.black)
                            }
                            .frame(alignment: .leading)
                        }
                        .padding(7)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.main1Color, lineWidth: 1)
                        )
                    }
                    
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
                Spacer()

                Button(action: {
                    print("다음 버튼 클릭됨")
                    viewModel.signUp()
                    if viewModel.isNextButtonEnabled {
                        navigateToNextView = true
                    }
                }) {
                    Text("다음")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 320)
                        .background(viewModel.isNextButtonEnabled ? Color.sub2Color : Color.gray2)
                        .cornerRadius(8)
                }
                .padding()
                .disabled(!viewModel.isNextButtonEnabled)

                NavigationLink(destination: StartView().navigationBarBackButtonHidden(), isActive: $navigateToNextView) {
                    EmptyView()
                }
                .onAppear {
                    UIApplication.shared.hideKeyboard()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("입력제한"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("확인")))
            }
        }
    }
}



#if canImport(UIKit)
extension UIApplication {
    func hideKeyboard() {
        guard let window = windows.first else { return }
        let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapRecognizer.cancelsTouchesInView = false
        tapRecognizer.delegate = self
        window.addGestureRecognizer(tapRecognizer)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
#endif

#Preview {
    ProfileResearchView()
}
