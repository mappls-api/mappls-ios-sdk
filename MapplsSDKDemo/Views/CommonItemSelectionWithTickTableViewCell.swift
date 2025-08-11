//
//  CommonItemSelectionWithTickTableViewCell.swift
//  MapplsSDKDemo
//
//  Created by rento on 31/01/25.
//

import UIKit

class CommonItemSelectionWithTickTableViewCell: UITableViewCell {
    
    static let identifier: String = "CommonItemSelectionWithTickTableViewCell"
    
    var titleLabel: UILabel!
    var tickView: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
        tickView = UIImageView()
        tickView.contentMode = .scaleAspectFit
        tickView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tickView)
        
        NSLayoutConstraint.activate([
            tickView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            tickView.heightAnchor.constraint(equalToConstant: 30),
            tickView.widthAnchor.constraint(equalToConstant: 30),
            tickView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func select() {
        tickView.image = UIImage(named: "tick-icon")!
    }
    
    func deSelect() {
        tickView.image = nil
    }
}

extension CommonItemSelectionWithTickTableViewCell: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.titleLabel.textColor = theme.textPrimary
            self.contentView.backgroundColor = theme.backgroundPrimary
            self.backgroundColor = theme.backgroundPrimary
        }
    }
}
