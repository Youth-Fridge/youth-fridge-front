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
    @State private var smallClassNavigationPath = NavigationPath()
    @State private var currentTab: MainTabType = .home
    var body: some View {
        TabView(selection: $tabSelectionViewModel.selectedTab) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                tabView(for: tab)
                    .tabItem {
                        Label(tab.title, image: tab.imageName(selected: tabSelectionViewModel.selectedTab == tab))
                            .font(.pretendardMedium12)
                    }
                    .tag(tab)
            }
        }
        .tint(.gray5)
        .environmentObject(tabSelectionViewModel)
        .onChange(of: tabSelectionViewModel.selectedTab) { newTab in
            if newTab == .news {
                if shouldUpdateUrl {
                    shouldUpdateUrl = false
                } else {
                    shouldUpdateUrl = true
                    newsUrl = "https://m.blog.naver.com/hyangyuloum"
                }
            } else if newTab == .smallClass {
                currentTab = .smallClass
            } else {
                currentTab = newTab
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
            .id(tab == .home ? UUID() : nil)
            
        case .smallClass:
            NavigationView {
                SmallClassView(
                    onProfileImageClick: {
                        self.tabSelectionViewModel.selectedTab = .mypage
                    }
                )
            }
            .id(tab == .smallClass ? UUID() : nil)
            
        case .news:
            NavigationView {
                NewsView(urlToLoad: $newsUrl)
            }
            .id(tab == .news ? UUID() : nil)
            
        case .mypage:
            NavigationView {
                MyPageView(viewModel: MyPageViewModel(container: DIContainer(services: Services())))
            }
            .id(tab == .mypage ? UUID() : nil)
        }
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
