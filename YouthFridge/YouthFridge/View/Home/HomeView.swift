//
//  HomeView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    let profileImages = ["broccoli", "pea", "corn", "tomato", "branch", "pumpkin"]
    @State private var currentIndex = 0
    @State private var selectedImageIndex: Int = 0
    @State private var daysRemaining = 21 // 남은 일수
    private let colors: [Color] = [.red, .blue, .green, .orange]
    private let banners = ["banner1","banner2","banner3"]
    private let cards = [
        Card(name:"장금이",title: "초계 국수 만들어요", date: "7월 30일 화요일 오후 7시", location: "안서초등학교", tags: ["메뉴 추천","건강식"],ing: "모집중", imageName: "bigBasket"),
        Card(name:"장금이",title: "김치 담그기", date: "8월 15일 토요일 오전 10시", location: "시청 앞 광장", tags: ["메뉴 추천","건강식"],ing: "모집중", imageName: "bigBasket"),
        Card(name:"장금이",title: "떡 만들기", date: "9월 5일 일요일 오후 2시", location: "문화센터", tags: ["메뉴 추천","건강식"],ing: "모집중", imageName: "bigBasket")
    ]
    private let tabContents = [
        TabContent(imageName: "banner1", title: "우리 같이 미니 김장할래?", content: "김: 김치 만들고\n치: 치~ 인구 할래? 끝나고 웃놀이 한 판!", date: "10월 5일", ing: "모집중"),
        TabContent(imageName: "banner2", title: "포트락 파티에 널 초대할게", content: "각자 먹고 싶은거 가져와 다 함께\n 나눠먹는 ,,,,그런거 있잖아요~", date: "9월 12일", ing: "모집중"),
        TabContent(imageName: "banner3", title: "특별한 뱅쇼와 함께 하는 연말 파티", content: "제철과일로 만드는\n 뱅쇼와 함께 도란도란 이야기 나눠요 ", date: "11월 2일", ing: "모집중")
    ]
    var body: some View {
        NavigationView {
            VStack {
                CardScrollView(cards: cards)
                HStack {
                    newsCardView(content: "청년들이\n 더위를 이겨내는 법")
                        .frame(width: 152)
                        .padding(.leading, 20)

                    VStack(spacing: 10) {
                        DynamicTextCardView(daysRemaining: $daysRemaining)
                        SmallestCardView()
                    }
                    .frame(height: 252)
                    .padding(.trailing, 10)
                }

                HStack {
                    Button(action: {
                        // Add your action here
                    }) {
                        Text("공식소모임")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.leading, 30)
                    }
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.top, 35)

                TabView(selection: $currentIndex) {
                    ForEach(tabContents.indices, id: \.self) { index in
                        ZStack(alignment: .leading) {
                            Image(tabContents[index].imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width, height: 120)
                                .clipped()
                                .overlay(
                                    Rectangle()
                                        .fill(Color.black.opacity(0.4))
                                        .blur(radius: 1)
                                )
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text(tabContents[index].title)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer().frame(width: 30)
                                    Text(tabContents[index].ing)
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                }
                                Text(tabContents[index].content)
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                                Text(tabContents[index].date)
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                            }
                            .padding(10)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .padding(.leading, 25)
                .padding(.trailing, 25)
            }
            
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading:
                HStack {
                    Image("logo")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Image("typeLogo")
                        .resizable()
                        .frame(width: 80, height: 15)
                        

                }
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selectedImageIndex > 0 && selectedImageIndex <= profileImages.count {
                        Image(profileImages[selectedImageIndex - 1])
                            .resizable()
                            .frame(width: 36,height: 36)
                            .clipShape(Circle())
                    } else {
                        Image("Ellipse")
                            .resizable()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                    }
                    
                }
            }
            .onAppear {
                self.selectedImageIndex = getSelectedImageIndex()
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
                    .foregroundColor(.black)
                    .padding(.top,10)
                    .padding(.leading,15)

                if !content.isEmpty {
                    Text(content)
                        .font(.system(size: 14, weight: .medium))
                        .bold()
                        .foregroundColor(.black)
                        .padding()
                }
                Spacer()
                Image("newsIcon")
                    .resizable()
                    .padding(.leading, 70)
                
                
            }
            .background(
                Color.sub2Color
                .cornerRadius(10)
            )
        }
        .frame(height: 252)
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % cards.count
            }
        }
    }
    private func getSelectedImageIndex() -> Int {
        return UserDefaults.standard.integer(forKey: "profileImageNumber")
    }
}
struct CardScrollView: View {
    let cards: [Card]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(cards.indices, id: \.self) { index in
                    CardItemView(card: cards[index], backgroundColor: index % 2 == 0 ? .green1Color : .sub3Color)
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init())
    }
}
