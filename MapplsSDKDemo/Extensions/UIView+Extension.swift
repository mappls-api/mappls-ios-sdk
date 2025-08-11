//
//  UIView+Extension.swift
//  MapplsSDKDemo
//
//  Created by rento on 07/01/25.
//

import UIKit

extension UIView {
    func addBottomShadow(color: UIColor = .init(hexString: "#3C445B7A").withAlphaComponent(0.48)) {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .init(width: 0, height: 4)
    }
    
    func addShadow(color: UIColor = .gray.withAlphaComponent(0.3), radius: CGFloat, opacity: Float, offset: CGSize) {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
    }
}
