//
//  DIGIPINTopEntryView.swift
//  MapplsSDKDemo
//
//  Created by rento on 01/02/25.
//

import UIKit

protocol DIGIPINTopEntryViewDelegate: Sendable, AnyObject {
    func setDigipinBtnPressed(with coordinate: String) async
    func setCoordinateBtnPressed(with digiPin: String) async
}

class DIGIPINTopEntryView: UIView {
    
    weak var delegate: DIGIPINTopEntryViewDelegate?
    var digiPinField: UITextField!
    var coordinateField: UITextField!
    var digiPinSetBtn: UIButton!
    var coordinateSetBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        layer.cornerRadius = 15
        addShadow(radius: 4, opacity: 0.5, offset: .init(width: 0, height: 4))
        
        digiPinField = UITextField()
        digiPinField.placeholder = "Enter DIGIPIN"
        digiPinField.layer.borderWidth = 1
        digiPinField.font = UIFont(name: "Roboto-Regular", size: 15)
        digiPinField.leftView = .init(frame: .init(x: 0, y: 0, width: 10, height: 0))
        digiPinField.leftViewMode = .always
        digiPinField.layer.cornerRadius = 6
        digiPinField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        digiPinField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(digiPinField)
        
        NSLayoutConstraint.activate([
            digiPinField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            digiPinField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            digiPinField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            digiPinField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        coordinateField = UITextField()
        coordinateField.leftView = .init(frame: .init(x: 0, y: 0, width: 10, height: 0))
        coordinateField.leftViewMode = .always
        coordinateField.layer.cornerRadius = 6
        coordinateField.font = UIFont(name: "Roboto-Regular", size: 15)
        coordinateField.layer.borderWidth = 1
        coordinateField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        coordinateField.placeholder = "Enter Coordiante, eg. - \"22.5744,88.3629\""
        coordinateField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(coordinateField)
        
        NSLayoutConstraint.activate([
            coordinateField.leadingAnchor.constraint(equalTo: digiPinField.leadingAnchor),
            coordinateField.trailingAnchor.constraint(equalTo: digiPinField.trailingAnchor),
            coordinateField.topAnchor.constraint(equalTo: digiPinField.bottomAnchor, constant: 20),
            coordinateField.heightAnchor.constraint(equalTo: digiPinField.heightAnchor)
        ])
        
        digiPinSetBtn = UIButton(type: .system)
        digiPinSetBtn.layer.cornerRadius = 6
        digiPinSetBtn.layer.borderWidth = 1
        digiPinSetBtn.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        digiPinSetBtn.setTitle("Coordinate to DIGIPIN", for: .normal)
        digiPinSetBtn.addTarget(self, action: #selector(self.setDigiPinBtnPressed), for: .touchUpInside)
        digiPinSetBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(digiPinSetBtn)
        
        NSLayoutConstraint.activate([
            digiPinSetBtn.topAnchor.constraint(equalTo: coordinateField.bottomAnchor, constant: 10),
            digiPinSetBtn.leadingAnchor.constraint(equalTo: digiPinField.leadingAnchor),
            digiPinSetBtn.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10),
            digiPinSetBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        coordinateSetBtn = UIButton(type: .system)
        coordinateSetBtn.layer.cornerRadius = 6
        coordinateSetBtn.layer.borderWidth = 1
        coordinateSetBtn.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        coordinateSetBtn.setTitle("DIGIPIN to coordinate", for: .normal)
        coordinateSetBtn.addTarget(self, action: #selector(self.setCoordinateBtnPressed), for: .touchUpInside)
        coordinateSetBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(coordinateSetBtn)
        
        NSLayoutConstraint.activate([
            coordinateSetBtn.topAnchor.constraint(equalTo: digiPinSetBtn.topAnchor),
            coordinateSetBtn.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10),
            coordinateSetBtn.trailingAnchor.constraint(equalTo: digiPinField.trailingAnchor),
            coordinateSetBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    @objc func setCoordinateBtnPressed() {
        Task {
            await delegate?.setCoordinateBtnPressed(with: digiPinField.text ?? "")
        }
    }
    
    @objc func setDigiPinBtnPressed() {
        Task {
            await delegate?.setDigipinBtnPressed(with: coordinateField.text ?? "")
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
    }
}

extension DIGIPINTopEntryView:  AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.backgroundColor = theme.backgroundPrimary
            self.digiPinField.textColor = theme.textPrimary
            self.coordinateField.textColor = theme.textPrimary
            self.digiPinSetBtn.setTitleColor(theme.textPrimary, for: .normal)
            self.coordinateSetBtn.setTitleColor(theme.textPrimary, for: .normal)
            self.digiPinField.layer.borderColor = theme.strokeBorder.cgColor
            self.coordinateField.layer.borderColor = theme.strokeBorder.cgColor
            self.digiPinSetBtn.backgroundColor = theme.backgroundSecondary
            self.coordinateSetBtn.backgroundColor = theme.backgroundSecondary
        }
    }
}
