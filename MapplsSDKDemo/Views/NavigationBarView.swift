//
//  NavigationBarView.swift
//  MapplsSDKDemo
//
//  Created by rento on 08/01/25.
//

import UIKit

protocol NavigationProtocol: Sendable, AnyObject {
    func navigateBack() async
}

class NavigationBarView: UIView {
    
    weak var delegate: NavigationProtocol?
    
    var backButton: UIButton!
    var titleLbl: UILabel!
    
    convenience init(title: String) {
        self.init(frame: .zero)
        titleLbl.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        backButton = UIButton()
        backButton.setImage(UIImage(named: "left-arrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            backButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 25),
            backButton.widthAnchor.constraint(equalToConstant: 25)
        ])
        
        titleLbl = UILabel()
        titleLbl.numberOfLines = 0
        titleLbl.font = UIFont(name: "Roboto-Medium", size: 21)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLbl)
        
        NSLayoutConstraint.activate([
            titleLbl.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 20),
            titleLbl.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLbl.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -100)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    @objc func backButtonPressed() {
        Task {
            await delegate?.navigateBack()
        }
    }
}

extension NavigationBarView: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.backgroundColor = theme.backgroundPrimary
            self.titleLbl.textColor = theme.textPrimary
        }
    }
}
