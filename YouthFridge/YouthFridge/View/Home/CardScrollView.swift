//
//  CardScrollView.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/28/24.
//

import Foundation
import SwiftUI

struct CardScrollView: View {
    let cards: [Card]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if cards.isEmpty {
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray1)
                            .frame(width: 350, height: 140)
                            .cornerRadius(10)
                        HStack {
                            Text("오늘의 밥친구를 구해볼까요?")
                                .font(.pretendardSemiBold20)
                                .padding(.leading, 20)
                                .foregroundColor(.black)
                                .padding(.bottom,40)
                           
                        }
                        ZStack {
                            Image("cardLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 102,height: 80)
                                .offset(x: 254, y: 29)
                        }
                        
                        
                    }
                }else {
                    ForEach(cards) { card in
                        NavigationLink(destination: ShowInviteView(
                            viewModel: ShowInviteViewModel(),
                            invitationId: card.id, recruiting: card.ing
                        ).toolbar(.hidden, for: .tabBar)) {
                            CardItemView(card: card, backgroundColor: card.backgroundColor)
                        }
                    }
                }
            }
            .padding(.top, 30)
            .padding(.leading, 20)
            .padding(.bottom, 25)
        }
    }
}

struct CardItemView: View {
    let card: Card
    let backgroundColor: Color
    
    var body: some View {
        CardView(
            viewModel: CardViewModel(card: card),
            backgroundColor: backgroundColor
        )
    }
}
