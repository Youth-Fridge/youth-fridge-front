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
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ShadowNavigationBar()
                
                ScrollView {
                    VStack(spacing: 0) {
                        content
                            .padding(.horizontal, 10)
                            .padding(.leading, 5)
                        
                        ZStack {
                            shadowView
                                .padding(.top, 20)
                                .padding(.bottom, -30)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                participantView
                                toDoSection
                                responseSection
                                rulesSection
                            }
                            .padding(.horizontal, 15)
                            .padding(.top, 25)
                        }
                    }
                }
                .padding(.top, 10)
            }
            .navigationTitle("신청 내역")
            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarBackButtonHidden(true)
            //            .toolbar {
            //                ToolbarItem(placement: .navigationBarLeading) {
            //                    Button(action: {
            //                        dismiss()
            //                    }) {
            //                        Image("left-arrow")
            //                            .resizable()
            //                    }
            //                }
            //                ToolbarItem(placement: .navigationBarTrailing) {
            //                    Image(viewModel.myUser!.profilePicture)
            //                        .resizable()
            //                        .frame(width: 40, height: 40)
            //                }
            //            }
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
                
                Text("4/7명")
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
        }
    }
    
    var toDoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Text("TO DO")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                
                Text("운영사항")
                    .font(.subheadline)
                    .fontWeight(.regular)
            }
            .padding()
            
            HStack(alignment: .top, spacing: 10) {
                Image("Ellipse20")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .offset(y: -30)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("365일 식단 조절러")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.bottom, 10)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 204, height: 60)
                            .background(Color.gray1)
                            .cornerRadius(6)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("안서마트에서 장보기")
                                .font(Font.custom("Pretendard", size: 12))
                            
                            Text("감탄 스시 같이 먹기")
                                .font(Font.custom("Pretendard", size: 12))
                        }
                        .padding(20)
                        .foregroundColor(Color.gray6)
                    }
                    .padding(.bottom, -25)
                }
                .padding(.leading, 5)
            }
            .padding()
        }
    }
    
    var responseSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
                .background(Color.gray.opacity(0.5))
            
            HStack {
                Text("참석 응답")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                
                Text("응답 필수사항")
                    .font(.subheadline)
                    .fontWeight(.regular)
            }
            
            VStack(spacing: 10) {
                HStack {
                Image("Ellipse20")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                
                    HStack(spacing: 10) {
                        Button(action: {
                            print("참석 버튼")
                        }) {
                            Text("참석")
                                .font(Font.custom("Pretendard", size: 14).weight(.medium))
                                .foregroundColor(Color.gray6)
                                .frame(width: 65, height: 29)
                                .background(Color.sub2)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            print("미참석 버튼")
                        }) {
                            Text("미참석")
                                .font(Font.custom("Pretendard", size: 14).weight(.medium))
                                .foregroundColor(Color.gray6)
                                .frame(width: 77, height: 29)
                                .background(Color.gray2)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.leading, 10)
                }
                .padding(.bottom, -20)
            }
            .padding(.top, 10)
        }
        .padding()
    }
    
    var rulesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
                .background(Color.gray.opacity(0.5))
            
            HStack {
                Text("참여자 규칙")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                
                Text("운영사항")
                    .font(.subheadline)
                    .fontWeight(.regular)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("* 모임 참여가 어려울 시, 모임 일자 ")
                + Text("기준 2일 전까지")
                    .fontWeight(.bold)
                    .underline()
                + Text(" 미참석 버튼을 눌러 호스트에게 전달해 주세요.")
                Text("* 참여 응답 후 모임 미참석 시, 다음 참여에 불이익이 있을 수 있습니다.")
                Text("* 호스트의 주도로 소모임 내에서 진행되는 활동을 잘 따라주세요.")
                Text("* 불건전한 만남 및 문제 상황 발생을 방지하기 위해 관리자가 상시 모니터링 중입니다.")
                Text("* 문의사항 또는 문제 발생 시 ")
                + Text("문의처")
                    .fontWeight(.bold)
                    .underline()
                + Text("로 문의 부탁드립니다.")
            }
            .font(.footnote)
            .foregroundColor(Color.gray4)
        }
        .padding()
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let services = Services()
        let container = DIContainer(services: services)
        ActivityDetailView(viewModel: ActivityCardViewModel(title: "스시 먹부림", date: "7월 30일 화요일 오후 7시", location: "안서 초등학교", daysLeft: 21, imageName: "image1"))
    }
}
