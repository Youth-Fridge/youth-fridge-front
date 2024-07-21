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
        Card(name:"장금이",title: "초계 국수 만들어요", date: "7월 30일 화요일 오후 7시", location: "안서초등학교", tags: ["메뉴 추천","건강식","요리"],ing: "모집중"),
        Card(name:"장금이",title: "김치 담그기", date: "8월 15일 토요일 오전 10시", location: "시청 앞 광장",tags: ["메뉴 추천","건강식","요리"],ing: "모집중"),
        Card(name:"장금이",title: "떡 만들기", date: "9월 5일 일요일 오후 2시", location: "문화센터",tags: ["메뉴 추천","건강식","요리"],ing: "모집중")
    ]
    private let tabContents = [
        TabContent(imageName: "banner1", title: "우리 같이 미니 김장할래?", content: "김: 김치 만들고\n치: 치~ 인구 할래? 끝나고 웃놀이 한 판!", date: "10월 5일", ing: "모집중"),
        TabContent(imageName: "banner2", title: "포트락 파티에 널 초대할게", content: "각자 먹고 싶은거 가져와 다 함께\n 나눠먹는 ,,,,그런거 있잖아요~", date: "9월 12일", ing: "모집중"),
        TabContent(imageName: "banner3", title: "특별한 뱅쇼와 함께 하는 연말 파티", content: "제철과일로 만드는\n 뱅쇼와 함께 도란도란 이야기 나눠요 ", date: "11월 2일", ing: "모집중")
    ]
    var body: some View {
        NavigationView {
            VStack() {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(cards.indices, id: \.self) { index in
                            CardView(
                                viewModel: CardViewModel(card: cards[index]),
                                card: cards[index],
                                backgroundColor: index % 2 == 0 ? .green1Color : .sub3Color,
                                tags: cards[index].tags
                            )
                            
                        }
                    }
                    .padding(.top,30)
                    .padding(.leading,20)
                    .padding(.bottom,25)
                }

                    HStack() {
                        newsCardView(content: "청년들이\n 더위를 이겨내는 법")
                            .frame(width: 152)
                            .padding(.leading,20)
                        Spacer()
                        VStack(spacing: 10) {
                            DynamicTextCardView(daysRemaining: $daysRemaining)
                            smallestCardView()
                               
                                
                        }
                        .frame( height: 252)
                        .padding(.trailing,10)
                        Spacer()
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
                .padding(.top,35)
                TabView(selection: $currentIndex) {
                    ForEach(tabContents.indices, id: \.self) { index in
                        ZStack(alignment:.leading) {
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
                            VStack() {
                                HStack {
                                    Text(tabContents[index].title)
                                        .font(.system(size: 16,weight: .bold))
                                        .foregroundColor(.white)
                                        
                                    Spacer().frame(width: 30)
                                    Text(tabContents[index].ing)
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                }
                                Spacer().frame(height: 5)
                                Text(tabContents[index].content)
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                                Spacer().frame(height: 10)
                                Text(tabContents[index].date)
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                            }
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
                    .padding(.top,10)
                    .padding(.leading,15)

                if !content.isEmpty {
                    Text(content)
                        .font(.system(size: 14, weight: .medium))
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                }
                Spacer()
                Image("newsIcon")
                    .resizable()
                    .padding(.leading, 70)
                
                
            }
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
        .frame(width: 190,height: 120)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0) // 그림자 추가
    }
}


private func smallestCardView() -> some View {
    VStack(alignment: .leading) {
        Text("초대장")
            .font(.system(size: 20, weight: .semibold))
            .padding(.top,15)
            .frame(width: 52)
        
        HStack(spacing: 10) {
            Text("만들기")
                .font(.system(size: 12))
                .bold()
                .padding(.leading, 15)
                .padding(.trailing,15)
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
                .padding(.leading,70)
                .padding(.top,-30)
        }
    }
    .padding(.leading, 15)
    .background(Color.sub2Color)
    .cornerRadius(10)
    .frame(width: 190,height: 120)
    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 0)
}
struct TabContent {
    let imageName: String
    let title: String
    let content: String
    let date: String
    let ing: String
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init())
    }
}
