//
//  SwitchTableViewCell.swift
//  MapplsSDKDemo
//
//  Created by rento on 30/01/25.
//

import UIKit

protocol SwitchTableViewCellDelegate: Sendable, AnyObject {
    func switchValueChanged(isOn: Bool, tag: Int) async
}

class SwitchTableViewCell: UITableViewCell {
    
    static let identifier: String = "SwitchTableViewCell"
    
    weak var delegate: SwitchTableViewCellDelegate?
    var data: SwitchCase!
    var switchButton: UISwitch!
    var titleLbl: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        titleLbl = UILabel()
        titleLbl.font = UIFont(name: "Roboto-Regular", size: 17)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLbl)
        
        NSLayoutConstraint.activate([
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        switchButton = UISwitch()
        switchButton.addTarget(self, action: #selector(self.switchButtonPressed), for: .valueChanged)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(switchButton)
        
        NSLayoutConstraint.activate([
            switchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            switchButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            switchButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setData(item: SwitchCase) {
        self.data = item
        titleLbl.text = item.title
    }
    
    @objc func switchButtonPressed() {
        Task {
            await delegate?.switchValueChanged(isOn: switchButton.isOn, tag: switchButton.tag)
        }
    }
}

extension SwitchTableViewCell: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.contentView.backgroundColor = .clear
            self.titleLbl.backgroundColor = .clear
            self.backgroundColor = .clear
            self.switchButton.onTintColor = theme.accentBrandPrimary
        }
    }
}
