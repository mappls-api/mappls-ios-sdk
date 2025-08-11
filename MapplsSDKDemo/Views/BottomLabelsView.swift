//
//  BottomLabelsView.swift
//  MapplsSDKDemo
//
//  Created by rento on 03/02/25.
//

import UIKit

class BottomLabelsView: UIView {
    
    var topLbl: UILabel!
    var bottomLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        topLbl = UILabel()
        topLbl.font = UIFont(name: "Roboto-Regular", size: 15)
        topLbl.numberOfLines = 0
        topLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topLbl)
        
        NSLayoutConstraint.activate([
            topLbl.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            topLbl.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            topLbl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        bottomLbl = UILabel()
        bottomLbl.numberOfLines = 0
        bottomLbl.font = UIFont(name: "Roboto-Regular", size: 15)
        bottomLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLbl)
        
        NSLayoutConstraint.activate([
            bottomLbl.leadingAnchor.constraint(equalTo: topLbl.leadingAnchor),
            bottomLbl.trailingAnchor.constraint(equalTo: topLbl.trailingAnchor),
            bottomLbl.topAnchor.constraint(equalTo: topLbl.bottomAnchor, constant: 10)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
}

extension BottomLabelsView: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.backgroundColor = theme.backgroundPrimary
            self.topLbl.textColor = theme.textPrimary
            self.bottomLbl.textColor = theme.textPrimary
        }
    }
}
