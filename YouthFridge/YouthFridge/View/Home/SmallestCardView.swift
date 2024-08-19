//
//  SmallestCardView.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/8/24.
//

import Foundation
import SwiftUI

struct SmallestCardView: View {
    @State private var showCreateInviteView = false
    
    var body: some View {
        NavigationLink(destination: CreateInviteView(), isActive: $showCreateInviteView) {
            ZStack {
                Color.sub3Color
                    .cornerRadius(10)
                    .frame(width: 190, height: 120)
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 0)
                
                // Image
                Image("letter")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 106, height: 110)
                    .offset(x: 45, y: 25)
                
                VStack(alignment: .leading) {
                    
                    Text("초대장")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.top, 20)
                        .foregroundColor(Color.white)
                    
                    Text("만들기")
                        .font(.system(size: 12))
                        .bold()
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                        .padding(.top, 3)
                        .padding(.bottom, 3)
                        .background(Color.main1Color)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .padding(.top, -5)
                    
                    Spacer()
                }
                .padding(.leading, -80)
            }
            .frame(width: 190, height: 120)
            .onTapGesture {
                showCreateInviteView.toggle()
            }
        }
        .buttonStyle(PlainButtonStyle()) 
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SmallestCardView()
    }
}

