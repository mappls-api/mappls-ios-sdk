//
//  CameraCollectionViewCell.swift
//  MapplsSDKDemo
//
//  Created by rento on 10/01/25.
//

import UIKit

class SubOptionHashable: Hashable {
    let id: UUID
    var icon: UIImage?
    var title: String
    var subTitle: String
    
    init(icon: UIImage?, title: String, subTitle: String) {
        self.id = UUID()
        self.icon = icon
        self.title = title
        self.subTitle = subTitle
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: SubOptionHashable, rhs: SubOptionHashable) -> Bool {
        return lhs.id == rhs.id
    }
}

class SubOptionCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "CameraCollectionViewCell"
    
    var titleLbl: UILabel!
    var subTitleLbl: UILabel!
    var iconImgView: UIImageView!
    var mapImage: UIImageView?
    var titleLblLeadingConstraint: NSLayoutConstraint = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        contentView.addBottomShadow()
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        
        mapImage = UIImageView(image: UIImage(named: "map-snapshot"))
        mapImage?.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mapImage!)
        
        NSLayoutConstraint.activate([
            mapImage!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mapImage!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mapImage!.topAnchor.constraint(equalTo: contentView.topAnchor),
            mapImage!.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        iconImgView = UIImageView()
        iconImgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImgView)
        
        NSLayoutConstraint.activate([
            iconImgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconImgView.topAnchor.constraint(equalTo: mapImage!.bottomAnchor, constant: 20),
            iconImgView.heightAnchor.constraint(equalToConstant: 37),
            iconImgView.widthAnchor.constraint(equalToConstant: 37)
        ])
        
        titleLbl = UILabel()
        titleLbl.font = UIFont(name: "Roboto-Regular", size: 16)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLbl)
        
        titleLblLeadingConstraint = titleLbl.leadingAnchor.constraint(equalTo: iconImgView.trailingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([
            titleLblLeadingConstraint,
            titleLbl.topAnchor.constraint(equalTo: iconImgView.topAnchor)
        ])
        
        subTitleLbl = UILabel()
        subTitleLbl.numberOfLines = 0
        subTitleLbl.font = UIFont(name: "Roboto-Regular", size: 14)
        subTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subTitleLbl)
        
        NSLayoutConstraint.activate([
            subTitleLbl.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor),
            subTitleLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            subTitleLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            subTitleLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 1)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setData(data: SubOptionHashable) {
        titleLbl.text = data.title
        subTitleLbl.text = data.subTitle
        if let image = data.icon {
            iconImgView.image = image
        }else {
            iconImgView.isHidden = true
            titleLblLeadingConstraint.isActive = false
            titleLblLeadingConstraint = titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
            titleLblLeadingConstraint.isActive = true
        }
    }
}


extension SubOptionCollectionViewCell: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.contentView.backgroundColor = theme.backgroundSecondary
            self.contentView.layer.borderColor = theme.strokeBorder.cgColor
            self.titleLbl.textColor = theme.textPrimary
            self.subTitleLbl.textColor = theme.textSecondary
        }
    }
}
