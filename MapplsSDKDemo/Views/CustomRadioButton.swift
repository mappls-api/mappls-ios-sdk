//
//  CustomRadioButton.swift
//  MapplsSDKDemo
//
//  Created by rento on 29/01/25.
//

import UIKit

class CustomRadioButton: UIButton {
    
    var isToggled: Bool = false {
        didSet {
            if isToggled {
                setOn()
            }else {
                setOff()
            }
        }
    }
    var offTintColor: UIColor = ThemeColors.default.textPrimary {
        didSet {
            if !isToggled {
                layer.borderColor = offTintColor.cgColor
            }
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
    
    private convenience init(type: UIButton.ButtonType) {
        self.init(frame: .zero)
    }
    
    convenience init() {
        self.init(frame: .zero)
        commonInit()
    }
    
    func commonInit() {
        layer.borderWidth = 2
        layer.cornerRadius = (bounds.width-2)/2
        
        setOff()
        
        addTarget(self, action: #selector(self.handleTap), for: .touchUpInside)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if !isToggled {
            offTintColor = ThemeColors.default.textPrimary
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = (bounds.width)/2
    }
    
    @objc func handleTap() {
        toggle()
    }
    
    func toggle() {
        isToggled = !isToggled
        if isToggled {
            setOn()
        }else {
            setOff()
        }
    }
    
    func setOn() {
        setImage(UIImage(named: "switch-on"), for: .normal)
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        layer.borderColor = UIColor.clear.cgColor
    }
    
    func setOff() {
        setImage(nil, for: .normal)
        layer.borderColor = offTintColor.cgColor
    }
}
