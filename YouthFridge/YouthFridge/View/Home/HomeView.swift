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
    private let colors: [Color] = [.red, .blue, .green, .orange]
    private let banners = ["banner1","banner2","banner3"]
    private let cards = [
        Card(title: "초계 국수 만들어요", date: "7월 30일 화요일 오후 7시", location: "안서초등학교", tags: ["메뉴 추천","건강식","요리"]),
        Card(title: "김치 담그기", date: "8월 15일 토요일 오전 10시", location: "시청 앞 광장",tags: ["메뉴 추천","건강식","요리"]),
        Card(title: "떡 만들기", date: "9월 5일 일요일 오후 2시", location: "문화센터",tags: ["메뉴 추천","건강식","요리"])
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
                                backgroundColor: index % 2 == 0 ? .green1Color : .sub3Color,
                                tags: cards[index].tags
                            )
                            .frame(width: 340)
                        }
                    }
                    .padding(.top,50)
                    .padding(.leading,25)
                }

                    HStack(spacing: 5) {
                        newsCardView(content: "청년들이\n 더위를 이겨내는 법")
                            .frame(width: 152, height: 252)
                        
                        VStack(spacing: 10) {
                            DynamicTextCardView(daysRemaining: $daysRemaining)
                                .padding(.bottom, 10)
                            smallestCardView()
                               
                                
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: 252)
                    }
                Spacer()
                HStack() {
                    Button(action: {
                    }) {
                        Text("공식소모임")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(alignment: .leading)
                            .padding(.leading,30)
                        
                    }
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                    Spacer()
                }
                TabView(selection: $currentIndex) {
                    ForEach(banners.indices, id: \.self) { index in
                        Image(banners[index])
                            .resizable()
                            .scaledToFill()
                            .tag(index)
                        
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .padding(.bottom,30)
                .padding(.leading,25)
                .padding(.trailing,25)
                
            
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
    private func newsCardView(content: String) -> some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Today\n뉴스레터")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)

                if !content.isEmpty {
                    Text(content)
                        .font(.system(size: 14, weight: .medium))
                        .bold()
                        .foregroundColor(.white)
                }
                Image("newsIcon")
                    .resizable()
                    .frame(width: 55, height: 64)
                    .padding(.leading, 25)
                    .padding(.top, 30)
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.6), Color.black.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .cornerRadius(10)
            )
        }
        .frame(height: 252)
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 0)
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
    @Binding var daysRemaining: Int

    var body: some View {
        ZStack {
                    Color.white.opacity(0.92)
                        .cornerRadius(10)
            VStack(alignment: .leading) {
                Text("우리 약속까지")
                    .font(.system(size: 16,weight: .semibold))
                HStack {
                    ForEach(Array(String(daysRemaining)), id: \.self) { char in
                        Text(String(char))
                            .font(.system(size: 40,weight: .bold))
                            .bold()
                            .foregroundColor(Color.sub2Color)
                            .frame(width: 40, height: 48)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray2Color, lineWidth: 1)
                            )
                    }
                    Text("일 남았어요")
                        .font(.system(size: 16,weight: .semibold))
                        .padding(.bottom, -30)
                        
                }
            }
        }
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0) // 그림자 추가
    }
}


private func smallestCardView() -> some View {
    VStack(alignment: .leading) {
        Text("초대장")
            .font(.system(size: 20, weight: .semibold))
            .padding(.top,10)
        HStack(spacing: 10) {
            Text("만들기")
                .font(.system(size: 14))
                .bold()
                .padding(.leading, 15)
                .padding(.trailing,15)
                .padding(.top, 5)
                .padding(.bottom, 5)
                .background(Color.main1Color)
                .foregroundColor(.white)
                .cornerRadius(5)
            
            Image("letter")
                .resizable()
                .frame(maxWidth: .infinity)
        }
    }
    .padding(.leading, 10)
    .background(Color.sub2Color)
    .cornerRadius(10)
    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 0)
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init())
    }
}
