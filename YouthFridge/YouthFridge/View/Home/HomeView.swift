//
//  HomeView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var currentIndex = 0
    @State private var daysRemaining = 21 // 남은 일수

    private let cards = [
        Card(title: "초계 국수 만들어요", date: "7월 30일 화요일 오후 7시", location: "안서초등학교", tags: ["먹부림좌","즐거움","낭만"]),
        Card(title: "김치 담그기", date: "8월 15일 토요일 오전 10시", location: "시청 앞 광장",tags: ["먹부림좌","즐거움","낭만"]),
        Card(title: "떡 만들기", date: "9월 5일 일요일 오후 2시", location: "문화센터",tags: ["먹부림좌","즐거움","낭만"])
    ]
    var body: some View {
            NavigationView {
                VStack(spacing: 20) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(cards.indices, id: \.self) { index in
                                CardView(
                                    viewModel: CardViewModel(card: cards[index]),
                                    card: cards[index],
                                    backgroundColor: index % 2 == 0 ? .main1Color : .sub3Color,
                                    tags: cards[index].tags
                                )
                                .frame(width: 340)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    HStack(spacing: 10) {
                                        smallCardView(title: "Today\n뉴스레터", content: "청년들이\n 더위를 이겨내는 법", backgroundColor: Color.black.opacity(0.5))
                                            .frame(width: UIScreen.main.bounds.width * 0.5, height: 252)

                                        VStack(spacing: 10) {
                                            DynamicTextCardView(title: "우리 약속까지", daysRemaining: $daysRemaining, backgroundColor: Color.white.opacity(0.2))
                                                .frame(height: 120)
                                            smallestCardView(title: "초대장", content: "만들기", backgroundColor: Color.yellow)
                                                .frame(height: 120)
                                        }
                                        .frame(width: UIScreen.main.bounds.width * 0.5)
                                    }
                                    .padding(.horizontal)
                                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading:
                    HStack {
                        Image("logo")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("청년냉장고")
                            .font(.headline)
                    }
                )
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image("Ellipse")
                            .resizable()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                    }
                }
                .onAppear {
                    startTimer()
                }
                
            }
        
        }
    
    // Small Card View
    private func smallCardView(title: String, content: String, backgroundColor: Color = Color.white) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 20,weight: .semibold))
                .foregroundColor(.white)
            Spacer()
            if !content.isEmpty {
                Text(content)
                    .font(.system(size: 14))
                    .bold()
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.black)
                .blur(radius: 100)
        )
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % cards.count
            }
        }
    }
}

struct DynamicTextCardView: View {
    let title: String
    @Binding var daysRemaining: Int
    let backgroundColor: Color

    var body: some View {
        ZStack {
            backgroundColor
            VerticalBlurView(blurAmount: 20)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                HStack {
                    ForEach(Array(String(daysRemaining)), id: \.self) { char in
                        Text(String(char))
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color.sub2Color)
                            .frame(width: 40, height: 48)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                    }
                    Text("일 남았어요")
                        .font(.system(size: 16))
                        .bold()
                }
            }
            .padding()
        }
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
}

private func smallestCardView(title: String, content: String, backgroundColor: Color = Color.white) -> some View {
    VStack(alignment: .leading) {
        Text(title)
            .font(.headline)
        if !content.isEmpty {
            Text(content)
                .font(.system(size: 14))
                .bold()
                .foregroundColor(.white)
        }
    }
    .padding()
    .background(Color.sub2Color)
    .cornerRadius(10)
    .frame(maxWidth: .infinity)
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init())
    }
}

