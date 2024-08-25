//
//  MainTabView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI
import WebKit

struct MainTabView: View {
    @State private var newsUrl: String = "https://m.blog.naver.com/hyangyuloum"
    @State private var shouldUpdateUrl = false
    @StateObject private var tabSelectionViewModel = TabSelectionViewModel()
    @StateObject private var smallClassViewModel = SmallClassViewModel()

    var body: some View {
        TabView(selection: $tabSelectionViewModel.selectedTab) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                tabView(for: tab)
                    .tabItem {
                        Label(tab.title, image: tab.imageName(selected: tabSelectionViewModel.selectedTab == tab))
                    }
                    .tag(tab)
            }
        }
        .tint(.black)
        .environmentObject(tabSelectionViewModel)
        .onChange(of: tabSelectionViewModel.selectedTab) { newTab in
            if newTab == .news {
                if shouldUpdateUrl {
                    shouldUpdateUrl = false
                } else {
                    shouldUpdateUrl = true
                    newsUrl = "https://m.blog.naver.com/hyangyuloum"
                }
            }
        }
    }

    @ViewBuilder
    private func tabView(for tab: MainTabType) -> some View {
        switch tab {
        case .home:
            NavigationView {
                HomeView(
                    viewModel: .init(),
                    newsUrl: $newsUrl,
                    onProfileImageClick: {
                        self.tabSelectionViewModel.selectedTab = .mypage
                    },
                    onNewsButtonPress: {
                        self.tabSelectionViewModel.selectedTab = .news
                    },
                    onLatestNewsFetched: {
                        self.shouldUpdateUrl = true
                    }
                )
            }
        case .smallClass:
            NavigationView {
                SmallClassView()
            }
        case .news:
            NavigationView {
                NewsView(urlToLoad: $newsUrl)
            }
        case .mypage:
            NavigationView {
                MyPageView(viewModel: MyPageViewModel(container: DIContainer(services: Services())))
            }
        }
    }
    
    private func resetHomeView() {
        
    }
    
    private func resetSmallClassView() {
    }
    init() {
        let image = UIImage.gradientImageWithBounds(
            bounds: CGRect(x: 0, y: 0, width: UIScreen.main.scale, height: 8),
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
