//
//  AutosearchResultCell.swift
//  MapplsSDKDemo
//
//  Created by rento on 10/01/25.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    static let identifier: String = "SearchResultCell"
    
    var titleLbl: UILabel!
    var subTitleLbl: UILabel!
    var arrowImgV: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        titleLbl = UILabel()
        titleLbl.font = .systemFont(ofSize: 17, weight: .medium)
        titleLbl.numberOfLines = 0
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLbl)
        
        NSLayoutConstraint.activate([
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
        
        subTitleLbl = UILabel()
        subTitleLbl.font = .systemFont(ofSize: 15, weight: .regular)
        subTitleLbl.numberOfLines = 0
        subTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subTitleLbl)
        
        NSLayoutConstraint.activate([
            subTitleLbl.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor),
            subTitleLbl.trailingAnchor.constraint(equalTo: titleLbl.trailingAnchor),
            subTitleLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 2),
            subTitleLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        arrowImgV = UIImageView(image: UIImage(systemName: "arrow.up.right")?.withRenderingMode(.alwaysTemplate))
        arrowImgV.contentMode = .scaleAspectFit
        arrowImgV.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(arrowImgV)
        
        NSLayoutConstraint.activate([
            arrowImgV.leadingAnchor.constraint(equalTo: titleLbl.trailingAnchor, constant: 5),
            arrowImgV.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImgV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            arrowImgV.heightAnchor.constraint(equalToConstant: 25),
            arrowImgV.widthAnchor.constraint(equalToConstant: 25)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setUpUI(with item: SearchResultHashable) {
        titleLbl.text = item.suggestion.placeName
        subTitleLbl.text = item.suggestion.placeAddress
    }
}

extension SearchResultCell: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.arrowImgV.tintColor = theme.textPrimary
            self.contentView.backgroundColor = theme.backgroundPrimary
            self.titleLbl.textColor = theme.textPrimary
            self.subTitleLbl.textColor = theme.textSecondary
        }
    }
}
