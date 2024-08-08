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
    var cards: [Card] {
        viewModel.cards
    }
    
    var tabContents: [TabContent] {
        viewModel.tabContents
    }
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
//                        NavigationLink(destination: ShowInviteView(tabContent: viewModel.tabContents[index])) {
                            ZStack(alignment: .leading) {
                                Image(tabContents[index].imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 350, height: 120)
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
                                        Spacer()
                                        HStack {
                                            Text(tabContents[index].ing)
                                                .background(Color.clear)
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                                .modifier(CustomViewModifier(color: .white))
                                                .padding([.trailing], 10)
                                        }
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
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        //}
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .padding(.horizontal, 20)
                
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
