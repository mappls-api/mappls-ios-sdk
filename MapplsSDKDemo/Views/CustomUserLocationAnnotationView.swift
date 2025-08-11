//
//  CustomUserLocationAnnotationView.swift
//  MapplsSDKDemo
//
//  Created by rento on 10/01/25.
//

import UIKit
import MapplsMap

class CustomUserLocationAnnotationView: MGLUserLocationAnnotationView {
    
    var imageView: UIImageView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imageView = UIImageView(image: UIImage(named: "ic_marker_focused")!)
        imageView.frame = bounds
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
    }
}
