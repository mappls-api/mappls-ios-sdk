//
//  PlaceAddressDetailView.swift
//  MapplsSDKDemo
//
//  Created by rento on 09/01/25.
//

import UIKit

class PlaceAddressDetailView: UIView {
    
    var placeNameLbl: UILabel!
    var placeAddressLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 10
        placeNameLbl = UILabel()
        placeNameLbl.font = UIFont(name: "Roboto-Medium", size: 17)
        placeNameLbl.numberOfLines = 0
        placeNameLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeNameLbl)
        
        NSLayoutConstraint.activate([
            placeNameLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            placeNameLbl.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            placeNameLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
        
        placeAddressLbl = UILabel()
        placeAddressLbl.font = UIFont(name: "Roboto-Regular", size: 15)
        placeAddressLbl.numberOfLines = 0
        placeAddressLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeAddressLbl)
        
        NSLayoutConstraint.activate([
            placeAddressLbl.leadingAnchor.constraint(equalTo: placeNameLbl.leadingAnchor),
            placeAddressLbl.topAnchor.constraint(equalTo: placeNameLbl.bottomAnchor, constant: 5),
            placeAddressLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setData(placeName: String, placeAddress: String) {
        placeNameLbl.text = placeName
        placeAddressLbl.text = placeAddress
    }
}

extension PlaceAddressDetailView: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.backgroundColor = theme.backgroundPrimary
            self.placeNameLbl.textColor = theme.textPrimary
            self.placeAddressLbl.textColor = theme.textSecondary
        }
    }
}
