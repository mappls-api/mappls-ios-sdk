//
//  RadioButtonItemView.swift
//  MapplsSDKDemo
//
//  Created by rento on 29/01/25.
//

import UIKit

class RadioButtonItemView: UIView {
    
    var radioButton: CustomRadioButton!
    var titleLabel: UILabel!
    var isToggled: Bool = false {
        didSet {
            radioButton.isToggled = isToggled
        }
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
        radioButton = CustomRadioButton()
        radioButton.addTarget(self, action: #selector(self.radioButtonToggled), for: .touchUpInside)
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(radioButton)
        
        NSLayoutConstraint.activate([
            radioButton.heightAnchor.constraint(equalToConstant: 25),
            radioButton.widthAnchor.constraint(equalToConstant: 25),
            radioButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            radioButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 17)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    @objc func radioButtonToggled() {
        isToggled = radioButton.isToggled
    }
}

