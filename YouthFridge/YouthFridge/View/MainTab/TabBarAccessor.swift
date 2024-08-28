//
//  TabBarControllerModifier.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/28/24.
//

import SwiftUI

class TabBarVisibilityManager: ObservableObject {
    @Published var isTabBarHidden: Bool = false
}
private struct TabBarAccessor: UIViewControllerRepresentable {
    @EnvironmentObject var visibilityManager: TabBarVisibilityManager

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        DispatchQueue.main.async {
            if let tabBarController = viewController.parent as? UITabBarController {
                self.updateTabBarVisibility(for: tabBarController)
            }
        }
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    private func updateTabBarVisibility(for tabBarController: UITabBarController) {
        tabBarController.tabBar.isHidden = visibilityManager.isTabBarHidden
    }
}
private struct TabBarVisibilityKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

extension EnvironmentValues {
    var isTabBarHidden: Bool {
        get { self[TabBarVisibilityKey.self] }
        set { self[TabBarVisibilityKey.self] = newValue }
    }
}

struct TabBarVisibilityModifier: ViewModifier {
    @EnvironmentObject var visibilityManager: TabBarVisibilityManager

    func body(content: Content) -> some View {
        content
            .background(TabBarAccessor()
                .environmentObject(visibilityManager))
    }
}



extension View {
    func tabBarVisibility() -> some View {
        self.modifier(TabBarVisibilityModifier())
    }
}

