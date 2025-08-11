//
//  OptionsViewCell.swift
//  MapplsSDKDemo
//
//  Created by rento on 07/01/25.
//

import UIKit

class OptionsHashable: Hashable {
    let id: UUID
    var icon: UIImage?
    var title: String
    
    init(icon: UIImage?, title: String) {
        self.id = UUID()
        self.icon = icon
        self.title = title
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: OptionsHashable, rhs: OptionsHashable) -> Bool {
        return lhs.id == rhs.id
    }
}

class OptionsViewCell: UICollectionViewCell {
    
    static let identifier: String = "OptionsViewCell"
    private var iconView: UIImageView!
    private var titleLbl: UILabel!
    private var iconBgView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        iconBgView = UIView()
        iconBgView.addShadow(color: .gray.withAlphaComponent(0.2), radius: 3, opacity: 1.0, offset: .init(width: 0, height: 2))
        iconBgView.layer.cornerRadius = 10
        iconBgView.layer.cornerCurve = .continuous
        iconBgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconBgView)
        
        NSLayoutConstraint.activate([
            iconBgView.heightAnchor.constraint(equalToConstant: 80),
            iconBgView.widthAnchor.constraint(equalToConstant: 80),
            iconBgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconBgView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconBgView.addSubview(iconView)
        
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: iconBgView.centerYAnchor),
            iconView.centerXAnchor.constraint(equalTo: iconBgView.centerXAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 28),
            iconView.widthAnchor.constraint(equalToConstant: 28)
        ])
        
        titleLbl = UILabel()
        titleLbl.font = UIFont(name: "Roboto-Regular", size: 14)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLbl)
        
        NSLayoutConstraint.activate([
            titleLbl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLbl.topAnchor.constraint(equalTo: iconBgView.bottomAnchor, constant: 10),
            titleLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setData(data: OptionsHashable) {
        iconView.image = data.icon
        titleLbl.text = data.title
    }
}

extension OptionsViewCell: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.iconBgView.backgroundColor = theme.backgroundSecondary
            self.titleLbl.textColor = theme.textPrimary
        }
    }
}
