// CreateInviteView.swift
// YouthFridge
//
// Created by 김민솔 on 7/23/24.
// 초대장 작성

import SwiftUI

struct CreateInviteView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = CreateInviteViewModel()
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading) {
                tabButtons
                if viewModel.selectedTab == 0 {
                    StepOneView(viewModel: viewModel)
                } else {
                    StepTwoView(viewModel: viewModel)
                }
                Spacer()
            }
            .navigationTitle("초대장 작성")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image("left-arrow")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let profileImageUrl = viewModel.profileImageUrl {
                        if let profile = ProfileImage.from(rawValue: profileImageUrl) {
                            let profileImage = profile.imageName
                            Image(profileImage)
                                .resizable()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("알림"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("확인"))
                )
            }
        }
        .onAppear {
            viewModel.fetchProfileImage()
        }
    }
    
    private var tabButtons: some View {
        HStack(spacing: 16) {
            tabButton(title: "STEP1", tabIndex: 0) {
                viewModel.selectedTab = 0
            }
            tabButton(title: "STEP2", tabIndex: 1) {
                viewModel.selectedTab = 1
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
    }

    private func tabButton(title: String, tabIndex: Int, action: (() -> Void)? = nil) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                if tabIndex != viewModel.selectedTab {
                    action?()
                } else {
                    viewModel.selectedTab = tabIndex
                }
            }
        }) {
            Text(title)
                .font(viewModel.selectedTab == tabIndex ? .pretendardSemiBold16 : .pretendardMedium16)
                .frame(width: 60, height: 5)
                .padding()
                .background(viewModel.selectedTab == tabIndex ? Color.main1Color : Color.gray1Color)
                .foregroundColor(viewModel.selectedTab == tabIndex ? .white : .black)
                .cornerRadius(8)
        }
    }
    

}

struct StepOneView: View {
    @ObservedObject var viewModel: CreateInviteViewModel
    @State private var showEmojiModal = false
    @State private var isShowingProfileSelector = false
    @State private var selectedProfileImageName: String? = nil
    
    let times: [String] = [
        "12:00", "13:00", "14:00", "15:00", "16:00", "17:00",
        "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"
    ]
    
    private var filteredEndTimes: [String] {
        times.filter { $0 > viewModel.selectedStartTime }
    }
    
    @State private var isDatePickerVisible: Bool = false

    var body: some View {
        ScrollView {
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            isDatePickerVisible = false
                        }
                        UIApplication.shared.hideKeyBoard()
                    }
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    Text("이모지 내역")
                        .font(.pretendardSemiBold18)
                        .padding(.top, 15)
                        .padding(.bottom, 2)
                        .padding(.horizontal, 22)
                    
                    Button(action: {
                        showEmojiModal = true
                        isShowingProfileSelector = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray1Color)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray2Color, lineWidth: 1)
                                )
                            
                            if let emojiName = Emoji.from(rawValue: viewModel.emojiNumber) {
                                Image(emojiName.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            } else {
                                Image("cameraIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $isShowingProfileSelector) {
                        EmojiSelectionView(nickname: $viewModel.nickname, selectedImage: $selectedProfileImageName, selectedEmojiNumber: $viewModel.emojiNumber, isShowing: $isShowingProfileSelector)
                            .presentationDetents([.medium, .large])
                            .presentationDragIndicator(.hidden)
                    }
                    .animation(.easeInOut, value: isShowingProfileSelector)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 22)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("모임 명")
                            .font(.pretendardSemiBold18)
                        
                        TextField("10글자 이내", text: $viewModel.name)
                            .font(.pretendardRegular14)
                            .onChange(of: viewModel.name) { newValue in
                                if newValue.count > 10 {
                                    viewModel.name = String(newValue.prefix(10))
                                }
                            }
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(
                                        Color(uiColor: .gray2),
                                        lineWidth: 1
                                    )
                            }
                    }
                    .padding(.bottom, 35)
                    .padding(.horizontal, 22)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("세부 활동 계획")
                                .font(.pretendardSemiBold18)
                            Text("최소 2개")
                                .font(.pretendardRegular12)
                                .foregroundColor(.gray3)
                        }
                        
                        ForEach(viewModel.activityPlans.indices, id: \.self) { index in
                            TextField("15글자 이내", text: $viewModel.activityPlans[index])
                                .font(.pretendardRegular14)
                                .onChange(of: viewModel.activityPlans[index]) { newValue in
                                    if newValue.count > 15 {
                                        viewModel.activityPlans[index] = String(newValue.prefix(15))
                                    }
                                }
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(
                                            Color(uiColor: .gray2),
                                            lineWidth: 1
                                        )
                                }
                        }
                        
                        Button(action: {
                            viewModel.addActivityPlan()
                        }) {
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .foregroundColor(Color.gray1)
                                    .cornerRadius(6)
                                
                                HStack(spacing: 5) {
                                    Image("plus-button")
                                    
                                    Text("추가해 보세요")
                                        .font(.pretendardRegular12)
                                        .foregroundColor(Color.gray3)
                                }
                                .padding(.leading, 10)
                            }
                        }
                        .frame(width: 350, height: 45)
                    }
                    .padding(.bottom, 25)
                    .padding(.horizontal, 22)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("관심사 키워드 선택")
                                .font(.pretendardSemiBold18)
                            Text("최대 2개")
                                .font(.pretendardRegular12)
                                .foregroundColor(.gray3)
                        }
                        
                        LazyVStack(alignment: .leading, spacing: 12) {
                            let columns = 4
                            let rows = viewModel.keywords.count / columns + (viewModel.keywords.count % columns > 0 ? 1 : 0)
                            ForEach(0..<rows, id: \.self) { rowIndex in
                                HStack(spacing: 7) {
                                    ForEach(0..<columns, id: \.self) { columnIndex in
                                        let index = rowIndex * columns + columnIndex
                                        if index < viewModel.keywords.count {
                                            let keyword = viewModel.keywords[index]
                                            Button(action: {
                                                viewModel.toggleKeyword(keyword)
                                            }) {
                                                Text(keyword)
                                                    .lineLimit(1)
                                                    .fixedSize(horizontal: true, vertical: false)
                                                    .padding(.horizontal, 22)
                                                    .padding(.vertical, 10)
                                                    .background(viewModel.selectedKeywords.contains(keyword) ? Color.main1 : Color.gray1)
                                                    .font(.pretendardSemiBold12)
                                                    .foregroundColor(viewModel.selectedKeywords.contains(keyword) ? .white : .gray6)
                                                    .cornerRadius(20)
                                            }
                                        } else {
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 25)
                    .padding(.horizontal, 22)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("모임 장소")
                            .font(.pretendardSemiBold18)
                        
                        TextField("8글자 이내", text: $viewModel.launchPlace)
                            .padding()
                            .font(.pretendardRegular14)
                            .foregroundColor(.gray3)
                            .overlay {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(
                                        Color(uiColor: .gray2),
                                        lineWidth: 1
                                    )
                            }
                            .onChange(of: viewModel.launchPlace) { newValue in
                                        if newValue.count > 8 {
                                            viewModel.launchPlace = String(newValue.prefix(8))
                                        }
                                    }
                    }
                    .padding(.bottom, 25)
                    .padding(.horizontal, 22)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("모임 인원")
                            .font(.pretendardSemiBold18)
                        Menu {
                            ForEach(1..<9) { number in
                                Button(action: {
                                    viewModel.totalMember = number
                                }) {
                                    Text("\(number)")
                                }
                            }
                        } label: {
                            HStack {
                                Text("\(viewModel.totalMember)")
                                    .font(.pretendardRegular14)
                                    .foregroundColor(Color.gray3)
                                Spacer()
                                Image(systemName: "arrowtriangle.down.fill")
                                    .resizable()
                                    .frame(width: 16, height: 12)
                                    .foregroundColor(Color.gray6)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray2Color, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.bottom, 25)
                    .padding(.horizontal, 22)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("모임 일자")
                                .font(.pretendardSemiBold18)
                            Image("calendar")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .onTapGesture {
                                    withAnimation {
                                        isDatePickerVisible.toggle()
                                    }
                                }
                        }
                        
                        HStack {
                            Text(DateFormatter.generalDateFormatter.string(from: viewModel.launchDate))
                                .font(.pretendardRegular14)
                                .foregroundColor(Color.gray3)
                                .padding(.leading, 17)
                                .onTapGesture {
                                    withAnimation {
                                        isDatePickerVisible.toggle()
                                    }
                                }
                            
                            Spacer()
                        }
                        .frame(width: 350, height: 50)
                        .background(Color.clear)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .inset(by: 0.50)
                                .stroke(Color.gray2)
                        )
                        
                        if isDatePickerVisible {
                            DatePicker(
                                "",
                                selection: $viewModel.launchDate,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .labelsHidden()
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                            .tint(Color.accentColor)
                            .frame(maxWidth: .infinity)
                            .transition(.opacity)
                        }
                    }
                    .padding(.bottom, 25)
                    .padding(.horizontal, 22)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("모임 시간")
                            .font(.pretendardSemiBold18)
                        
                        HStack(spacing: 16) {
                            Menu {
                                ForEach(times, id: \.self) { time in
                                    Button(action: {
                                        viewModel.selectedStartTime = time
                                        if viewModel.selectedEndTime < time {
                                            viewModel.selectedEndTime = time
                                        }
                                    }) {
                                        Text(time)
                                            .foregroundColor(Color.gray3)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(viewModel.selectedStartTime.isEmpty ? "시작 시간" : viewModel.selectedStartTime)
                                        .font(.pretendardRegular14)
                                        .foregroundColor(Color.gray3)
                                    Spacer()
                                    Image(systemName: "arrowtriangle.down.fill")
                                        .resizable()
                                        .frame(width: 16, height: 12)
                                        .foregroundColor(Color.gray6)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray2, lineWidth: 1)
                                )
                            }
                            
                            Menu {
                                ForEach(times, id: \.self) { time in
                                    Button(action: {
                                        viewModel.selectedEndTime = time
                                    }) {
                                        Text(time)
                                            .foregroundColor(Color.gray3)
                                    }
                                    .disabled(!filteredEndTimes.contains(time))
                                }
                            } label: {
                                HStack {
                                    Text(viewModel.selectedEndTime.isEmpty ? "종료 시간" : viewModel.selectedEndTime)
                                        .font(.pretendardRegular14)
                                        .foregroundColor(Color.gray3)
                                    Spacer()
                                    Image(systemName: "arrowtriangle.down.fill")
                                        .resizable()
                                        .frame(width: 16, height: 12)
                                        .foregroundColor(Color.gray6)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray2, lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.bottom, 25)
                    .padding(.horizontal, 22)
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("오픈 채팅")
                                .font(.pretendardSemiBold18)
                                .padding(.bottom, 14)
                            Spacer()
                            if !viewModel.kakaoLink.isEmpty {
                                        if isValidKakaoOpenChatURL(viewModel.kakaoLink) {
                                            Text("유효한 링크입니다")
                                                .font(.pretendardMedium10)
                                                .padding(.bottom, 14)
                                        } else {
                                            Text("유효하지 않은 링크입니다")
                                                .font(.pretendardMedium10)
                                                .padding(.bottom, 14)
                                                .foregroundColor(.red)
                                        }
                                    } else {
                                        Text("")
                                            .padding(.bottom, 14)
                                    }
                                }
                        TextField("소통을 위한 카카오톡 오픈 채팅방 링크를 입력해주세요.", text: $viewModel.kakaoLink)
                            .font(.pretendardRegular14)
                            .foregroundColor(.gray3)
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(
                                        Color(uiColor: .gray2),
                                        lineWidth: 1
                                    )
                            }
                        
                            .frame(height: 20)

                            
                    }
                    .padding(.bottom, 25)
                    .padding(.horizontal, 22)
                }
            }
        }
        .sheet(isPresented: $isShowingProfileSelector) {
            EmojiSelectionView(nickname: $viewModel.nickname, selectedImage: $selectedProfileImageName, selectedEmojiNumber: $viewModel.emojiNumber, isShowing: $isShowingProfileSelector)
        }
        .scrollIndicators(.never)
    }
    func isValidKakaoOpenChatURL(_ url: String) -> Bool {
        let regex = "^https:\\/\\/open\\.kakao\\.com\\/o\\/[a-zA-Z0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: url)
    }
}

extension UIApplication {
    func hideKeyBoard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    CreateInviteView()
}
