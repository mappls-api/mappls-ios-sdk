//
//  CustomSegmentControl.swift
//  MapplsSDKDemo
//
//  Created by rento on 28/01/25.
//

import UIKit

class CustomSegmentControl: UISegmentedControl {
    
    var radius: CGFloat?
    
    private var segmentInset: CGFloat = 6 {
        didSet{
            if segmentInset == 0{
                segmentInset = 0.1
            }
        }
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        selectedSegmentIndex = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.radius ?? 0
        layer.cornerCurve = .continuous
        layer.masksToBounds = true
        
        let selectedImageViewIndex = numberOfSegments
        if let selectedView = subviews[selectedImageViewIndex] as? UIImageView {
            selectedView.backgroundColor = ThemeColors.default.accentBrandPrimary
            
            selectedView.bounds = selectedView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            selectedView.image = nil
            selectedView.layer.masksToBounds = true
            if let radius = radius {
                selectedView.layer.cornerRadius = radius - segmentInset/2
                selectedView.layer.cornerCurve = .continuous
            }
            
            selectedView.layer.removeAnimation(forKey: "SelectionBounds")
        }
    }
}
