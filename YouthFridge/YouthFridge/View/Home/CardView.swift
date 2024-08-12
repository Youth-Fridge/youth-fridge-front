//
//  CardView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: CardViewModel
    let backgroundColor: Color
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            HStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        viewModel.profileImage
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.leading)
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
                        Text(viewModel.card.formattedDateAndTime)
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
            .padding(.trailing, 10)
            .frame(width: 350, height: 140)
            .background(viewModel.card.backgroundColor)
            .cornerRadius(10)
            .foregroundColor(.white)
            
            viewModel.image
                .resizable()
                .frame(width: 70, height: 70)
                .padding(10)
        }
    }
}

struct CustomViewModifier: ViewModifier {
    var color: Color
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12,weight: .semibold))
            .padding(.top,5)
            .padding(.bottom,5)
            .padding(.leading,11)
            .padding(.trailing,11)
            .overlay(
                RoundedRectangle(cornerSize: CGSize(width: 30, height: 10))
                    .stroke(lineWidth: 1.5)
            )
            .foregroundColor(color)
    }
}
struct TextWithBackground: View {
    let text: String
    let backgroundColor: Color

    var body: some View {
        Text(text)
            .font(.system(size: 10,weight: .medium))
            .padding(.top,5)
            .padding(.bottom,5)
            .padding(.leading,11)
            .padding(.trailing,11)
            .background(Color.white)
            .foregroundColor(Color.gray4Color)
            .cornerRadius(20)
        
    }
}


