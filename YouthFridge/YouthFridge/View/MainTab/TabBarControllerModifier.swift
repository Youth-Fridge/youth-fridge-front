//
//  TabBarControllerModifier.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/28/24.
//

import SwiftUI

struct TabBarControllerModifier: UIViewControllerRepresentable {
    var isHidden: Bool
    var onViewWillAppear: () -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        DispatchQueue.main.async {
            onViewWillAppear()
        }
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let tabBarController = uiViewController.tabBarController {
            tabBarController.tabBar.isHidden = isHidden
        }
    }
}

extension View {
    func setTabBarHidden(_ isHidden: Bool, onViewWillAppear: @escaping () -> Void) -> some View {
        self.background(TabBarControllerModifier(isHidden: isHidden, onViewWillAppear: onViewWillAppear))
    }
}

