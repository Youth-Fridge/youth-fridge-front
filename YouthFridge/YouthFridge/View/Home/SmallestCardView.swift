//
//  SmallestCardView.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/8/24.
//

import Foundation
import SwiftUI

struct SmallestCardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("초대장")
                .font(.system(size: 20, weight: .semibold))
                .padding(.top, 15)
                .frame(width: 52, alignment: .leading)
                .foregroundColor(Color.white)
            
            HStack(spacing: 10) {
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
            }
            
            HStack {
                Spacer()
                Image("letter")
                    .resizable()
                    .frame(width: 106, height: 71)
                    .padding(.leading, 70)
                    .padding(.top, -30)
            }
        }
        .padding(.leading, 15)
        .background(Color.sub3Color)
        .cornerRadius(10)
        .frame(width: 190, height: 120)
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 0)
    }
}

struct SmallestCardView_Previews: PreviewProvider {
    static var previews: some View {
        SmallestCardView()
    }
}

