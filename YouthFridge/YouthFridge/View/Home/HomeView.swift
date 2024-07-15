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
    
    private let cards = [
        Card(title: "초계 국수 만들어요", date: "7월 30일 화요일 오후 7시", location: "안서초등학교", imageName: "soup"),
        Card(title: "김치 담그기", date: "8월 15일 토요일 오전 10시", location: "시청 앞 광장", imageName: "soup"),
        Card(title: "떡 만들기", date: "9월 5일 일요일 오후 2시", location: "문화센터", imageName: "soup")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [GridItem()]) {
                        ForEach(cards.indices, id: \.self) { index in
                            CardView(card: cards[index], backgroundColor: index % 2 == 0 ? .main1Color : .sub3Color)
                                                       .frame(width: 340)
                        }
                    }
                    .padding(.horizontal)
                }
                HStack(spacing: 10) {
                    smallCardView(title: "Today 뉴스레터", content: "")
                    smallCardView(title: "우리 양스까지", content: "21일 남았어요")
                    smallCardView(title: "초대장", content: "편집하기", backgroundColor: .yellow)
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
                .font(.headline)
            if !content.isEmpty {
                Text(content)
                    .font(.title)
                    .bold()
            }
        }
        .padding()
        .background(backgroundColor)
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init())
    }
}

