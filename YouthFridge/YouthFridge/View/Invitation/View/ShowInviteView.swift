//
//  ShowInviteView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/23/24.
//

import SwiftUI

struct ShowInviteView: View {
    var cell: CellModel
    @State private var isImageVisible: Bool = true
    @State private var rotationAngle: Double = 0
    @State private var isFlipped: Bool = false
    
    var body: some View {
        ZStack {
            Color.yellow // Replace with Color.sub2Color
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                Image("invitationLogo")
                    .resizable()
                    .frame(width: 280, height: 387)
                    .position(x: geometry.size.width - 140, y: geometry.size.height - 160)
            }
            
            VStack(alignment: .center) {
                Spacer()
                Text("당신을 초대합니다🎉")
                    .font(.system(size: 30, weight: .bold))
                
                ZStack {
                    // Background invitation image
                    Image("invitation")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 320, height: 436)
                        .padding(.leading, 30)
                        .padding(.top, 30)
                    
                    // Front content
                    if isImageVisible {
                        VStack {
                            Image("invitationImage3")
                                .resizable()
                                .frame(width: 260, height: 280)
                            Text("댄스파티에 놀러와!!")
                                .font(.system(size: 24, weight: .bold))
                        }
                        .padding(.bottom, 30)
                    }
                    // Back content
                    else {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image("Ellipse")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Text("댄스파티에 놀러와!!")
                                    .font(.system(size: 20, weight: .bold))
                            }
                            Divider()
                            VStack(alignment: .leading) {
                                Text("기간")
                                    .font(.system(size: 16,weight: .bold))
                                HStack {
                                    Text("우리 약속까지 ")
                                        .font(.system(size: 14,weight: .medium))
                                    Text("21")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.sub3Color)
                                    Text("일 남았어요")
                                        .font(.system(size: 14,weight: .medium))
                                }
                            }
                            Text("인원")
                                .font(.system(size: 16,weight: .bold))
                            Text("4/7명")
                                .font(.system(size: 14,weight: .medium))
                            Spacer()
                            Text("시간 및 장소")
                                .font(.system(size: 16,weight: .bold))
                            Text("7월 30일 화요일 오후 7시\n안서초등학교")
                                .font(.system(size: 14,weight: .medium))
                            Spacer()
                            Text("TO DO")
                                .font(.system(size: 16,weight: .bold))
                            VStack(alignment: .leading) {
                                Text("• 안서마트에서 장보기")
                                Text("• 감탄스시 같이 먹기")
                                Text("• 단대 카페에서 커피 마시기")
                            }
                            .font(.system(size: 14,weight: .medium))
                        }
                        .padding(30)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                        .frame(width: 320, height: 436)
                    }
                }
                .rotation3DEffect(
                    .degrees(rotationAngle),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .scaleEffect(isFlipped ? CGSize(width: -1, height: 1) : CGSize(width: 1, height: 1))
                
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        rotationAngle += 180
                        if rotationAngle == 180 {
                            isImageVisible.toggle()
                        } else if rotationAngle == 360 {
                            rotationAngle = 0
                            isImageVisible.toggle()
                        }
                    }
                    DispatchQueue.main.async {
                        isFlipped.toggle()
                    }
                }
                .toolbar(.hidden, for: .tabBar)
                Spacer()
                NavigationLink(destination: InviteFinalView()) {
                    Text("참여하기")
                        .font(.headline)
                        .foregroundColor(.yellow)
                        .padding()
                        .frame(maxWidth: 320)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 3)
                }
            }
        }
    }
}

#Preview {
    ShowInviteView(cell: CellModel(
        image: "invitationImage3",
        title: "댄스파티",
        tag: "문화",
        ing: "모집 중",
        numberOfPeople: "4/7"
    ))
}
