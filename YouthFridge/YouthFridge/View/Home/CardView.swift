//
//  CardView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: CardViewModel
    let card: Card
    let backgroundColor: Color
    let tags: [String]
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 30)
                    VStack(alignment: .leading, spacing: 2) {
                        HStack() {
                            Text("장금이")
                                .font(.system(size: 10))
                            Spacer()
                            HStack(spacing: 5) {
                                ForEach(viewModel.card.tags, id: \.self) { tag in
                                    TextWithBackground(text: tag, backgroundColor: Color.gray.opacity(0.2))
                                }
                               
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .cornerRadius(4)
                    }
                }
                Text(viewModel.card.title)
                    .font(.title2)
                    .bold()
                    .padding(.leading,40)
                HStack {
                    Image("clock")
                    Text(card.date)
                        .font(.system(size: 10))
                        
                }
                .padding(.leading,40)
                HStack {
                    Image("map-pin")
                    Text(card.location)
                        .font(.system(size: 10))
                }
                .padding(.leading,40)
            }
            Spacer()
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
        .foregroundColor(.white)
    }
}
struct TextWithBackground: View {
    let text: String
    let backgroundColor: Color

    var body: some View {
        Text(text)
            .font(.system(size: 10))
            .padding(5)
            .background(Color.white)
            .foregroundColor(Color.gray4Color)
            .cornerRadius(20)
        
    }
}


