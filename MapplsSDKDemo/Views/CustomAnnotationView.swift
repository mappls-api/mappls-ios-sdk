//
//  CustomAnnotationView.swift
//  MapplsSDKDemo
//
//  Created by rento on 16/01/25.
//

import UIKit
import MapplsMap

class CustomAnnotationView: MGLAnnotationView {
    
    var companyNameLbl: UILabel!
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
        frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        layer.cornerRadius = 15
        layer.cornerCurve = .continuous
        layer.shadowColor = UIColor.gray.withAlphaComponent(0.8).cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.8
        layer.shadowOffset = .init(width: 0, height: 4)
        
        imageView = UIImageView(image: UIImage(named: "mappls-logo-without-strok"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            imageView.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        companyNameLbl = UILabel()
        companyNameLbl.font = UIFont(name: "Roboto-Regular", size: 15)
        companyNameLbl.text = "C.E. Info Systems"
        companyNameLbl.textAlignment = .center
        companyNameLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(companyNameLbl)
        
        NSLayoutConstraint.activate([
            companyNameLbl.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            companyNameLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            companyNameLbl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
}

extension CustomAnnotationView: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.backgroundColor = theme.backgroundPrimary
            self.companyNameLbl.textColor = theme.textPrimary
        }
    }
}
