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
    @State private var selectedImageIndex: Int = 0
    @Binding var newsUrl: String
    
    let profileImages = ["broccoli", "pea", "corn", "tomato", "branch", "pumpkin"]
    private let colors: [Color] = [.red, .blue, .green, .orange]
    private let banners = ["banner1","banner2","banner3"]
    var onProfileImageClick: () -> Void
    var onNewsButtonPress: () -> Void
    var onLatestNewsFetched: () -> Void
    
    var cards: [Card] {
        viewModel.cards
    }
    
    var tabContents: [TabContent] {
        viewModel.tabContents
    }
    var body: some View {
        NavigationView {
            VStack {
                CardScrollView(cards: viewModel.cards)
                HStack {
                    newsCardView(content: "청년들이\n더위를 이겨내는 법")
                        .frame(width: 152)
                        .padding(.leading, 20)
                    
                    VStack(spacing: 10) {
                        DynamicTextCardView(viewModel: viewModel)
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
                    Spacer()
                }
                .padding(.top, 35)
                
                TabView(selection: $currentIndex) {
                    ForEach(tabContents.indices, id: \.self) { index in
                        NavigationLink(destination: ShowInviteView(
                            viewModel: ShowInviteViewModel(),
                            invitationId: tabContents[index].invitationId
                        )) {
                            ZStack(alignment: .leading) {
                                Image(tabContents[index].imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 350, height: 105)
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
                                    .padding(.bottom,35)
                                    Text(tabContents[index].date)
                                        .font(.system(size: 10))
                                        .foregroundColor(.white)
                                }
                                .padding(10)
                            }
                            .tag(index)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .padding(.horizontal, 20)
                
            }
            
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image("logo")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.leading, 5)
                        Image("typeLogo")
                            .resizable()
                            .frame(width: 80, height: 15)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        onProfileImageClick()
                    }) {
                        if let profileImageUrl = viewModel.profileImageUrl {
                            if let profile = ProfileImage.from(rawValue: profileImageUrl) {
                                let profileImage = profile.imageName
                                Image(profileImage)
                                    .resizable()
                                    .frame(width: 36, height: 36)
                                    .clipShape(Circle())
                            }
                           
                        }
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
        Button(action: {
            fetchLatestNewsUrl()
        }) {
            ZStack {
                Color.sub2Color
                    .cornerRadius(10)
                    .frame(width: 152, height: 252)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Today")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.gray6)
                        .padding(.top,14)
                    Text("뉴스레터")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray6)
                    if !content.isEmpty {
                        Text(content)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray6)
                            .frame(width: 105,height: 50)
                    }
                    Spacer()
                    
                    Image("newsIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 74, height: 86)
                        .offset(x: 65, y: 10)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
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
    
    private func fetchLatestNewsUrl() {
        NewsLetterService.shared.getNewsLetter { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.newsUrl = response.link
                    self.onLatestNewsFetched()
                    self.onNewsButtonPress()
                }
            case .failure(let error):
                print("Failed to fetch URL: \(error.localizedDescription)")
            }
        }
    }
}

struct CardScrollView: View {
    let cards: [Card]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(cards) { card in
                    NavigationLink(destination: ShowInviteView(
                        viewModel: ShowInviteViewModel(),
                        invitationId: card.id
                    )) {
                        CardItemView(card: card, backgroundColor: card.backgroundColor)
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

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(viewModel: .init(), newsUrl: $newsUrl, onNewsButtonPress: {
//            self.selectedTab = .news
//        })
//    }
//}
