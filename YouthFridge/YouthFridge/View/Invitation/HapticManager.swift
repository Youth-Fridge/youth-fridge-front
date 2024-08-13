//
//  HapticManager.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/13/24.
//

import SwiftUI

class HapticManager {
    static let instance = HapticManager()
    private init() {}
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

struct HapticsBootCamp: View {
    let hapticManager = HapticManager.instance
    var body: some View {
        VStack(spacing: 20) {
            Button("SUCCESS") { hapticManager.notification(type: .success) }
            Button("WARNING") { hapticManager.notification(type: .warning) }
            Button("ERROR") { hapticManager.notification(type: .error) }
            Divider()
            Button("SOFT") { hapticManager.impact(style: .soft) }
            Button("LIGHT") { hapticManager.impact(style: .light) }
            Button("MEDIUM") { hapticManager.impact(style: .medium) }
            Button("RIGID") { hapticManager.impact(style: .rigid) }
            Button("HEAVY") { hapticManager.impact(style: .heavy) }
        }
    }
}
