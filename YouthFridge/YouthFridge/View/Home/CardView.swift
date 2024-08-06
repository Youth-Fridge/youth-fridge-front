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
        HStack() {
            VStack(alignment: .leading) {
                            HStack(spacing: 0) {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 50, height: 30)
                                Text(viewModel.card.name)
                                    .font(.system(size: 10))
                                    .padding(.leading, 5)
                                Spacer()
                                HStack(spacing: 5) {
                                    ForEach(viewModel.card.tags, id: \.self) { tag in
                                        TextWithBackground(text: tag, backgroundColor: Color.gray.opacity(0.2))
                                    }       
                                    HStack {
                                        Text(viewModel.card.ing)
                                                   .background(Color.clear)
                                                   .foregroundColor(.white)
                                                   .cornerRadius(10)
                                                   .modifier(CustomViewModifier(color: .white))
                                                   .padding([.trailing], 10)
                                    }
                                }
                            
                        .foregroundColor(.white)
                        .padding(.leading, 6)
                        .cornerRadius(4)
 
                }
                Text(viewModel.card.title)
                    .font(.system(size: 26))
                    .bold()
                    .padding(.leading)
                
                HStack {
                    Image("clock")
                    Text(card.date)
                        .font(.system(size: 10))
                }
                .padding(.leading)
                HStack {
                    Image("map-pin")
                    Text(viewModel.card.location)
                        .font(.system(size: 10))
                        
                }
                .padding(.leading)
                
               
            }
            
        }
        .padding(.trailing,10)
        .frame(width: 350,height: 140)
        .background(backgroundColor)
        .cornerRadius(10)
        .foregroundColor(.white)
        
    }
}
struct CustomViewModifier: ViewModifier {
    var color: Color
    func body(content: Content) -> some View {
        content
            .font(.system(size: 10))
            .padding(6)
            .overlay(
                RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))
                                    .stroke(lineWidth: 1)
            )
            .foregroundColor(color)
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


