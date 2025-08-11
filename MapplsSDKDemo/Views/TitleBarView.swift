//
//  TitleBarView.swift
//  MapplsSDKDemo
//
//  Created by rento on 07/01/25.
//

import UIKit

class TitleBarView: UIView {
    
    var logoImgView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        logoImgView = UIImageView()
        logoImgView.contentMode = .scaleAspectFit
        logoImgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoImgView)
        
        NSLayoutConstraint.activate([
            logoImgView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            logoImgView.heightAnchor.constraint(equalToConstant: 35),
            logoImgView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
        
        if traitCollection.userInterfaceStyle == .light {
            self.logoImgView.image = UIImage(named: "logo-light-mode")
        }else {
            self.logoImgView.image = UIImage(named: "logo")
        }
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .light {
            self.logoImgView.image = UIImage(named: "logo-light-mode")
        }else {
            self.logoImgView.image = UIImage(named: "logo")
        }
    }
}

extension TitleBarView: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.backgroundColor = theme.backgroundPrimary
        }
    }
}
