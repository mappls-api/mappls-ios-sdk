//
//  MapStylesCollectionViewCell.swift
//  MapplsSDKDemo
//
//  Created by rento on 09/01/25.
//

import UIKit

class MapStylesCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "MapStylesCollectionViewCell"
    
    var styleIconImgView: UIImageView!
    var styleDisplayNameLbl: UILabel!
    var styleDescriptionLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        contentView.layer.cornerRadius = 10
        
        styleIconImgView = UIImageView()
        styleIconImgView.layer.cornerRadius = 10
        styleIconImgView.layer.masksToBounds = true
        styleIconImgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(styleIconImgView)
        
        NSLayoutConstraint.activate([
            styleIconImgView.heightAnchor.constraint(equalToConstant: 90),
            styleIconImgView.widthAnchor.constraint(equalToConstant: 120),
            styleIconImgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            styleIconImgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
        
        styleDisplayNameLbl = UILabel()
        styleDisplayNameLbl.numberOfLines = 0
        styleDisplayNameLbl.font = UIFont(name: "Roboto-Medium", size: 17)
        styleDisplayNameLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(styleDisplayNameLbl)
        
        NSLayoutConstraint.activate([
            styleDisplayNameLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            styleDisplayNameLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            styleDisplayNameLbl.trailingAnchor.constraint(equalTo: styleIconImgView.leadingAnchor, constant: -5)
        ])
        
        styleDescriptionLbl = UILabel()
        styleDescriptionLbl.numberOfLines = 0
        styleDescriptionLbl.font = UIFont(name: "Roboto-Regular", size: 15)
        styleDescriptionLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(styleDescriptionLbl)
        
        NSLayoutConstraint.activate([
            styleDescriptionLbl.leadingAnchor.constraint(equalTo: styleDisplayNameLbl.leadingAnchor),
            styleDescriptionLbl.topAnchor.constraint(equalTo: styleDisplayNameLbl.bottomAnchor, constant: 10),
            styleDescriptionLbl.trailingAnchor.constraint(equalTo: styleIconImgView.leadingAnchor, constant: -5)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setData(data: StylesHashable) {
        styleDisplayNameLbl.text = data.name
        styleDescriptionLbl.text = data.description
        if let iconUrl = data.iconUrl {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: URL(string: iconUrl)!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.styleIconImgView.image = image
                        }
                    }
                }
            }
        }
    }
}

extension MapStylesCollectionViewCell: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.contentView.backgroundColor = theme.backgroundPrimary
            self.styleDisplayNameLbl.textColor = theme.textPrimary
            self.styleDescriptionLbl.textColor = theme.textSecondary
        }
    }
}
