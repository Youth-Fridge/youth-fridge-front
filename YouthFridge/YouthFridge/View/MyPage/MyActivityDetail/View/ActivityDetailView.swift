//
//  ActivityDetailView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct ActivityDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ActivityCardViewModel
    @StateObject var detailViewModel: ActivityDetailModel
    
    init(invitationId: Int, viewModel: ActivityCardViewModel) {
        self.viewModel = viewModel
        _detailViewModel = StateObject(wrappedValue: ActivityDetailModel(invitationId: invitationId))
    }
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ShadowNavigationBar()
                
                VStack(spacing: 0) {
                    content
                        .padding(.horizontal, 10)
                        .padding(.leading, 5)
                    
                    ZStack {
                        shadowView
                            .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            participantView
                            rulesSection
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .padding(.top, 10)
            }
            .navigationTitle("신청 내역")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                detailViewModel.fetchDetailActivities()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image("left-arrow")
                            .resizable()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    let profileNumber = UserDefaults.standard.integer(forKey: "profileImageNumber")
                    if let profile = ProfileImage.from(rawValue: profileNumber) {
                        let profileImage = profile.imageName
                        
                        Image(profileImage)
                            .resizable()
                    }
                }
            }
        }
    }
    
    var content: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 6)
                Text(viewModel.date)
                    .font(.body)
                Text(viewModel.location)
                    .font(.body)
            }
            .padding()
            
            Spacer()
            
            Text("D - \(viewModel.daysLeft)")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .frame(width: 100, height: 60)
                .background(Color.research)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.main1, lineWidth: 1)
                )
                .padding(.bottom, 20)
                .padding(.trailing, 20)
        }
    }
    
    var shadowView: some View {
        Rectangle()
            .foregroundColor(.clear)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.15),
                radius: 25
            )
             .edgesIgnoringSafeArea(.all)
    }
    
    var participantView: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 15) {
                Text("참여자 명")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text("\(detailViewModel.currentMember)/\(detailViewModel.totalMember)명")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .frame(width: 75, height: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.main1, lineWidth: 1)
                    )
            }
            .padding()
            .padding(.top, 10)
            
            // 참여자 목록
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(detailViewModel.memberInfoList.indices, id: \.self) { index in
                    let participant = detailViewModel.memberInfoList[index]
                    VStack {
                        if let profileImage = ProfileImage.from(rawValue: participant.profileNumber) {
                            let imageName = profileImage.imageName
                            
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        }

                        Text(participant.nickName)
                            .font(.caption)
                            .padding(.top, 4)
                    }
                }
            }
        }
    }
    
    var rulesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
                .background(Color.gray.opacity(0.5))
                .padding(.vertical, 10)
            HStack {
                Text("호스트 규칙")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                
                Text("운영사항")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .padding(.bottom, 2)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("* 소모임 내에서 진행되는 모든 사항들은 호스트에게 달려있습니다.")
                Text("* 불건전한 만남 및 문제 상황 발생을 방지하기 위해 관리자가 상시 모니터링 중입니다.")
                Text("* 우수 소모임 호스트로 지정 시 리워드가 주어질 수 있습니다.")
                Text("* 문의사항 또는 문제 발생 시 문의처로 문의 부탁드립니다.")
            }
            .font(.footnote)
            
            .foregroundColor(.black)
        }
        .padding()
    }
}

//struct ActivityDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let services = Services()
//        let container = DIContainer(services: services)
//        ActivityDetailView(viewModel: ActivityCardViewModel(invitationId: 1, title: "스시 먹부림", date: "7월 30일 화요일 오후 7시", location: "안서 초등학교", startTime: "15시", daysLeft: 21, emojiNumber: 2), detailViewModel: ActivityDetailModel(totalMember: 5, currentMember: 3, memberInfoList: [MemberInfoList(nickName: "sujin", profileNumber: 2)]))
//    }
//}
