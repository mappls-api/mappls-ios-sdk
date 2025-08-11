//
//  InfoTableViewCell.swift
//  MapplsSDKDemo
//
//  Created by rento on 15/01/25.
//

import UIKit

class KeyValueHashable: Hashable {
    let id: UUID
    var key: String
    var value: String
    
    init(key: String, value: String) {
        self.id = UUID()
        self.key = key
        self.value = value
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: KeyValueHashable, rhs: KeyValueHashable) -> Bool {
        return lhs.id == rhs.id
    }
}

class InfoTableViewCell: UITableViewCell {
    
    static let identifer: String = "InfoTableViewCell"
    
    var keyLbl: UILabel!
    var valueLbl: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        keyLbl = UILabel()
        keyLbl.font = UIFont(name: "Roboto-Regular", size: 17)
        keyLbl.numberOfLines = 0
        keyLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(keyLbl)
        
        NSLayoutConstraint.activate([
            keyLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            keyLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            keyLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            keyLbl.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -10)
        ])
        
        valueLbl = UILabel()
        valueLbl.font = UIFont(name: "Roboto-Regular", size: 17)
        valueLbl.textAlignment = .right
        valueLbl.numberOfLines = 0
        valueLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(valueLbl)
        
        NSLayoutConstraint.activate([
            valueLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            valueLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            valueLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            valueLbl.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setData(data: KeyValueHashable) {
        keyLbl.text = data.key
        valueLbl.text = data.value
    }
}

extension InfoTableViewCell: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.keyLbl.textColor = theme.textPrimary
            self.valueLbl.textColor = theme.textSecondary
            self.contentView.backgroundColor = theme.backgroundPrimary
        }
    }
}
