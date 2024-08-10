// CreateInviteView.swift
// YouthFridge
//
// Created by 김민솔 on 7/23/24.
// 초대장 작성

import SwiftUI

struct CreateInviteView: View {
    @StateObject private var viewModel = CreateInviteViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack(spacing: 14) {
                    Button(action: {
                        viewModel.selectedTab = 0
                    }) {
                        Text("STEP1")
                            .font(.system(size: 16, weight: .bold))
                            .frame(width: 60, height: 5)
                            .padding()
                            .background(viewModel.selectedTab == 0 ? Color.main1Color : Color.gray1Color)
                            .foregroundColor(viewModel.selectedTab == 0 ? .white : .black)
                            .cornerRadius(8)
                    }
                    Button(action: {
                        viewModel.selectedTab = 1
                    }) {
                        Text("STEP2")
                            .font(.system(size: 16, weight: .bold))
                            .frame(width: 68, height: 5)
                            .padding()
                            .background(viewModel.selectedTab == 1 ? Color.main1Color : Color.gray1Color)
                            .foregroundColor(viewModel.selectedTab == 1 ? .white : .black)
                            .cornerRadius(8)
                    }
                }
                .padding(.top)
                
                if viewModel.selectedTab == 0 {
                    StepOneView(viewModel: viewModel)
                } else {
                    StepTwoView(viewModel: viewModel)
                        .onDisappear {
                             // Trigger the API call when STEP2 disappears
                             viewModel.createInvitation()
                         }
                }
                
                Spacer()
            }
            .navigationTitle("초대장 작성")
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 36, height: 36)
                }
            }
        }
    }
}
struct StepOneView: View {
    @ObservedObject var viewModel: CreateInviteViewModel
    @State private var showEmojiModal = false
    @State private var isShowingProfileSelector = false
    @State private var selectedProfileImage: UIImage? = nil
    @State private var selectedProfileImageName: String? = nil
    
    let times: [String] = [
        "12:00", "13:00", "14:00", "15:00", "16:00", "17:00",
        "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"
    ]

    private var filteredEndTimes: [String] {
        times.filter { $0 > selectedStartTime }
    }
    
    @State private var isDatePickerVisible: Bool = false
    @State private var selectedStartTime: String = ""
    @State private var selectedEndTime: String = ""
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("이모지 내역")
                    .font(.system(size: 18, weight: .semibold))
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
                        
                        Image("cameraIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                        if let selectedProfileImageName = selectedProfileImageName {
                            Image(selectedProfileImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $isShowingProfileSelector) {
                    EmojiSelectionView(selectedImage: $selectedProfileImageName, selectedEmojiNumber: $viewModel.emojiNumber, isShowing: $isShowingProfileSelector)
                        .presentationDetents([.medium, .large])
                }
                .animation(.easeInOut, value: isShowingProfileSelector)
                
                Text("모임 명")
                    .font(.system(size: 16, weight: .semibold))
                
                TextField("10글자 이내", text: $viewModel.name)
                    .font(.system(size: 16))
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                Color(uiColor: .gray2),
                                lineWidth: 1
                            )
                    }
                    .frame(height: 20)
                
                Text("세부 활동 계획")
                    .font(.system(size: 16, weight: .semibold))
                
                ForEach(viewModel.activityPlans.indices, id: \.self) { index in
                    TextField("15글자 이내", text: $viewModel.activityPlans[index])
                        .padding()
                        .font(.system(size: 16))
                        .cornerRadius(8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    Color(uiColor: .gray2),
                                    lineWidth: 1
                                )
                        }
                }
                
                Button(action: {
                    viewModel.addActivityPlan()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray1Color)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray2Color, lineWidth: 1)
                            )
                        
                        Text("추가해 보세요")
                            .foregroundColor(.gray3)
                            .cornerRadius(8)
                    }
                }
                .padding(.bottom,30)
                
                HStack {
                    Text("관심사 키워드 선택")
                        .font(.system(size: 16, weight: .semibold))
                    Text("최대 2개")
                        .font(.system(size: 12))
                }
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 5)], spacing: 10) {
                    ForEach(viewModel.keywords, id: \.self) { keyword in
                        Button(action: {
                            viewModel.toggleKeyword(keyword)
                        }) {
                            Text(keyword)
                                .padding()
                                .background(viewModel.selectedKeywords.contains(keyword) ? Color.sub2 : Color.gray1)
                                .font(.system(size: 12,weight: .semibold))
                                .foregroundColor(viewModel.selectedKeywords.contains(keyword) ? .white : .black)
                                .cornerRadius(20)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom,20)
                Text("모임 장소")
                    .font(.system(size: 16,weight: .semibold))
                TextField("8글자 이내", text: $viewModel.launchPlace)
                    .padding()
                    .font(.system(size: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                Color(uiColor: .gray2),
                                lineWidth: 1
                            )
                    }
                Text("모임 인원")
                    .font(.system(size: 16,weight: .semibold))
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
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray2Color, lineWidth: 1)
                    )
                }
                HStack {
                    Text("모임 일자")
                        .font(.system(size: 16, weight: .semibold))
                    Image("calendar")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 223, height: 40)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .inset(by: 0.50)
                                .stroke(Color(red: 0.89, green: 0.89, blue: 0.89), lineWidth: 0.50)
                        )
                    Text(dateFormatter.string(from: viewModel.launchDate))
                        .font(.system(size: 16))
                        .padding(.leading, 8)
                        .onTapGesture {
                            withAnimation {
                                isDatePickerVisible.toggle()
                            }
                        }
                }
                
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
                    .transition(.opacity)
                }
                
                Text("모임 시간")
                    .font(.system(size: 16,weight: .semibold))
                    .padding(.horizontal)
                
                HStack(spacing: 16) {
                    Menu {
                        ForEach(times, id: \.self) { time in
                            Button(action: {
                                selectedStartTime = time
                                viewModel.selectedStartTime = time
                                if selectedEndTime < time {
                                    selectedEndTime = time
                                }
                            }) {
                                Text(time)
                                    .foregroundColor(.black)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedStartTime.isEmpty ? "시작 시간" : selectedStartTime)
                                .foregroundColor(selectedStartTime.isEmpty ? .gray : .black)
                            Spacer()
                            Image(systemName: "arrowtriangle.down.fill")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                    
                    Menu {
                        ForEach(times, id: \.self) { time in
                            Button(action: {
                                viewModel.selectedEndTime = time
                                selectedEndTime = time
                            }) {
                                Text(time)
                                    .foregroundColor(filteredEndTimes.contains(time) ? .black : .gray)
                            }
                            .disabled(!filteredEndTimes.contains(time))
                        }
                    } label: {
                        HStack {
                            Text(selectedEndTime.isEmpty ? "종료 시간" : selectedEndTime)
                                .foregroundColor(selectedEndTime.isEmpty ? .gray : .black)
                            Spacer()
                            Image(systemName: "arrowtriangle.down.fill")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                
                Text("오픈 채팅")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.horizontal)
                
                TextField("소통을 위한 카카오톡 오픈 채팅방 링크를 입력해주세요.", text: $viewModel.kakaoLink)
                    .font(.system(size: 16))
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                Color(uiColor: .gray2),
                                lineWidth: 1
                            )
                    }
                    .frame(height: 20)
            }
        }
        .sheet(isPresented: $isShowingProfileSelector) {
            EmojiSelectionView(selectedImage: $selectedProfileImageName, selectedEmojiNumber: $viewModel.emojiNumber, isShowing: $isShowingProfileSelector)
        }
        .scrollIndicators(.never)
    }
}

#Preview {
    CreateInviteView()
}
