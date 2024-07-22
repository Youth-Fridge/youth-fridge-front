//
//  invitationView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/21/24.
//

import SwiftUI

struct invitationView: View {
    @State private var isImageVisible: Bool = true

    var body: some View {
        ZStack {
            Color.sub2Color
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
                    if isImageVisible {
                        Image("invitation")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 320, height: 436)
                            .padding(.leading, 30)
                            .padding(.top, 30)
                            .onTapGesture {
                                withAnimation {
                                    isImageVisible = false
                                }
                            }
                    } else {
                        VStack {
                            Color.white
                                .frame(width: 320, height: 436)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                            
                        }
                    }
                    
                    if isImageVisible {
                        VStack {
                            Image("invitationImage")
                                .resizable()
                                .frame(width: 260, height: 280)
                            Text("초계 국수 만들어요")
                                .font(.system(size: 24, weight: .bold))
                        }
                        .padding(.bottom, 30)
                    }
                }
                
                Spacer()
                NavigationLink(destination: ResearchView()) {
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
    invitationView()
}
