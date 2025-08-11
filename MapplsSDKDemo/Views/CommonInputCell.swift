//
//  CommonInputCell.swift
//  MapplsSDKDemo
//
//  Created by rento on 28/01/25.
//

import UIKit

class CommonInputCell: UIView {
    
    var textField: UITextField!
    var titleLbl: UILabel!
    
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
        titleLbl.font = UIFont(name: "Roboto-Regular", size: 14)
        titleLbl.numberOfLines = 0
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLbl)
        
        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: topAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLbl.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        textField = UITextField()
        textField.font = UIFont(name: "Roboto-Regular", size: 16)
        textField.layer.cornerRadius = 8
        textField.leftView = .init(frame: .init(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.layer.borderWidth = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: titleLbl.trailingAnchor),
            textField.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 2),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setTFPlaceHolder(placeholder: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: ThemeColors.default.textPlaceholder,
            NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16)!
        ]
        
        let placeholder: NSAttributedString = .init(string: placeholder, attributes: attributes)
        textField.attributedPlaceholder = placeholder
    }
    
    func setTitleLbl(title: String) {
        titleLbl.text = title
    }
}

extension CommonInputCell: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.backgroundColor = theme.backgroundPrimary
            self.textField.textColor = theme.textPrimary
            self.titleLbl.textColor = theme.textSecondary
            self.textField.layer.borderColor = theme.strokeBorder.cgColor
            self.textField.tintColor = theme.accentBrandPrimary
            self.textField.backgroundColor = theme.backgroundSecondary
        }
    }
}
