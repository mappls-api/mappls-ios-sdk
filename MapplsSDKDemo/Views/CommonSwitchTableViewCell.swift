//
//  CommonSwitchTableViewCell.swift
//  MapplsSDKDemo
//
//  Created by rento on 29/01/25.
//

import UIKit

protocol CommonSwitchTableViewCellDelegate: Sendable, AnyObject {
    func switchValueChanged(withTitle: String, isOn: Bool) async
}

class CommonSwitchTableViewCell: UITableViewCell {
    
    static let identifier: String = "CommonSwitchTableViewCell"
    
    weak var delegate: CommonSwitchTableViewCellDelegate?
    var titleLabel: UILabel!
    var switchButton: UISwitch!
    var parent: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        selectionStyle = .none
        
        parent = UIView()
        parent.layer.cornerRadius = 6
        parent.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(parent)
        
        NSLayoutConstraint.activate([
            parent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            parent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            parent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            parent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
        titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 17)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: parent.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -10)
        ])
        
        switchButton = UISwitch()
        switchButton.transform = CGAffineTransformMakeScale(0.7, 0.6)
        switchButton.addTarget(self, action: #selector(self.switchValueChanged), for: .valueChanged)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(switchButton)
        
        NSLayoutConstraint.activate([
            switchButton.heightAnchor.constraint(equalToConstant: 35),
            switchButton.widthAnchor.constraint(equalToConstant: 35),
            switchButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 2),
            switchButton.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -10)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    @objc func switchValueChanged() {
        Task {
            await delegate?.switchValueChanged(withTitle: titleLabel.text ?? "", isOn: switchButton.isOn)
        }
    }
}

extension CommonSwitchTableViewCell: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.parent.backgroundColor = theme.backgroundPrimary
            self.contentView.backgroundColor = theme.backgroundPrimary
            self.titleLabel.textColor = theme.textPrimary
            self.switchButton.onTintColor = theme.accentBrandPrimary
        }
    }
}
