//
//  CardView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI

struct CardView: View {
    let card: Card
    let backgroundColor: Color
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 30)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("장금이")
                            .font(.headline)
                        HStack(spacing: 15) {
                            Text("먹부림좌")
                            Text("즐거움")
                            Text("낭만")
                        }
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 6)
                        .background(Color.gray1)
                        .cornerRadius(4)
                    }
                }
                Text(card.title)
                    .font(.title2)
                    .bold()
                HStack {
                    Image(systemName: "calendar")
                    Text(card.date)
                }
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text(card.location)
                }
            }
            Spacer()
            Image(card.imageName)
                .resizable()
                .frame(width: 50, height: 50)
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
        .foregroundColor(.white)
    }
}
