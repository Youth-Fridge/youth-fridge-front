//
//  VerticalBlurView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/19/24.
//

import SwiftUI

struct VerticalBlurView: UIViewRepresentable {
    var blurAmount: CGFloat

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: .light)
        uiView.layer.mask = createMaskLayer(for: uiView.bounds)
    }

    private func createMaskLayer(for bounds: CGRect) -> CALayer {
        let maskLayer = CALayer()
        maskLayer.frame = bounds

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, NSNumber(value: Double(blurAmount / bounds.height)), 1]
        maskLayer.addSublayer(gradientLayer)

        return maskLayer
    }
}
