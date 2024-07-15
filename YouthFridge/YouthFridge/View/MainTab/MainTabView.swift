//
//  MainTabView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: MainTabType = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                Group {
                                    switch tab {
                                    case .home:
                                        AnyView(HomeView(viewModel: .init()))
                                    case .smallClass:
                                        AnyView(SmallClassView())
                                    case .news:
                                        AnyView(NewsView())
                                    case .mypage:
                                        AnyView(MyPageView(viewModel: MyPageViewModel(container: DIContainer(services: Services()))))
                                    }
                                }
                .tabItem {
                    Label(tab.title, image: tab.imageName(selected: selectedTab == tab))
                }
                .tag(tab)
            }
        }
        .tint(.black)
    }
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
    }
    
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
