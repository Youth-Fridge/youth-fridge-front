//
//  MainTabView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI
import WebKit

struct MainTabView: View {
    @State private var selectedTab: MainTabType = .home
    @State private var newsUrl: String = "https://m.blog.naver.com/hyangyuloum"
    @State private var shouldUpdateUrl = false
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                ForEach(MainTabType.allCases, id: \.self) { tab in
                    tabView(for: tab)
                        .tabItem {
                            Label(tab.title, image: tab.imageName(selected: selectedTab == tab))
                        }
                        .tag(tab)
                }
            }
            .tint(.black)
            .onChange(of: selectedTab) { newTab in
                if newTab == .news {
                    if shouldUpdateUrl {
                        shouldUpdateUrl = false
                    } else {
                        shouldUpdateUrl = true
                        newsUrl = "https://m.blog.naver.com/hyangyuloum"
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    @ViewBuilder
    private func tabView(for tab: MainTabType) -> some View {
        switch tab {
        case .home:
            HomeView(
                viewModel: .init(),
                newsUrl: $newsUrl,
                onProfileImageClick: {
                    self.selectedTab = .mypage 
                },
                onNewsButtonPress: {
                    self.selectedTab = .news
                },
                onLatestNewsFetched: {
                    self.shouldUpdateUrl = true
                }
                
            )
        case .smallClass:
            SmallClassView()
        case .news:
            NewsView(urlToLoad: $newsUrl)
        case .mypage:
            MyPageView(viewModel: MyPageViewModel(container: DIContainer(services: Services())))
        }
    }
    
    init() {
        let image = UIImage.gradientImageWithBounds(
            bounds: CGRect( x: 0, y: 0, width: UIScreen.main.scale, height: 8),
            colors: [
                UIColor.clear.cgColor,
                UIColor.black.withAlphaComponent(0.1).cgColor
            ]
        )
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemGray6
        
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = image
        
        UITabBar.appearance().standardAppearance = appearance
    }
    
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
