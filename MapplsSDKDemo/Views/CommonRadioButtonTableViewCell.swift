//
//  CommonRadioButtonTableViewCell.swift
//  MapplsSDKDemo
//
//  Created by rento on 29/01/25.
//

import UIKit

protocol CommonRadioButtonTableViewCellDelegate: Sendable, AnyObject {
    func didSelectRadioButton(title: String, value: String) async
}

class CommonRadioButtonTableViewCell: UITableViewCell {
    
    static let identifier: String = "CommonRadioButtonTableViewCell"
    
    weak var delegate: CommonRadioButtonTableViewCellDelegate?
    var titleLabel: UILabel!
    var radioButtonItems: [String] = []
    var radioButtonStack: UIStackView!
    var data: DrivingRangeRadioButton!
    var parent: UIView!
    
    convenience init(radioButtonItems: [String]) {
        self.init(frame: .zero)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder )
        commonInit()
    }
    
    func commonInit() {
        tag = 0
        selectionStyle = .none
        
        parent = UIView()
        parent.layer.cornerRadius = 6
        parent.layer.borderWidth = 1
        parent.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(parent)
        
        NSLayoutConstraint.activate([
            parent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            parent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            parent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            parent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
        titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: parent.topAnchor, constant: 15)
        ])
        
        setRadioView()
        
        if radioButtonItems.count > 0 {
            setRadioButtons(items: radioButtonItems, selectedItem: "")
        }
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setRadioView() {
        radioButtonStack = UIStackView()
        radioButtonStack.axis = .horizontal
        radioButtonStack.distribution = .fillProportionally
        radioButtonStack.spacing = 10
        radioButtonStack.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(radioButtonStack)
        
        NSLayoutConstraint.activate([
            radioButtonStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            radioButtonStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            radioButtonStack.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -15),
            radioButtonStack.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -15)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        radioButtonStack.removeFromSuperview()
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setData(item: DrivingRangeRadioButton) {
        data = item
        setTitle(title: item.title)
        setRadioButtons(items: item.radioItems, selectedItem: item.selectedItem)
    }
    
    func reloadRadioButtons(toggledButtonTag: Int) {
        for (index, item) in radioButtonStack.arrangedSubviews.enumerated() {
            if let view = item as? RadioButtonItemView {
                if index != toggledButtonTag {
                    view.isToggled = false
                }
            }
        }
    }
    
    func setRadioButtons(items: [String], selectedItem: String) {
        setRadioView()
        radioButtonItems = items
        
        for (index, item) in items.enumerated() {
            let radioButton: RadioButtonItemView = RadioButtonItemView()
            radioButton.setTitle(title: item)
            radioButton.radioButton.tag = index
            radioButton.radioButton.addTarget(self, action: #selector(self.radioButtonClicked), for: .touchUpInside)
            radioButton.translatesAutoresizingMaskIntoConstraints = false
            radioButtonStack.addArrangedSubview(radioButton)
            
            if selectedItem == item {
                radioButton.isToggled = true
            }
            
            NSLayoutConstraint.activate([
                radioButton.heightAnchor.constraint(equalToConstant: 25)
            ])
        }
    }
    
    @objc func radioButtonClicked(_ sender: UIButton) {
        if let view = radioButtonStack.arrangedSubviews[sender.tag] as? RadioButtonItemView {
            data.selectedItem = view.titleLabel.text ?? ""
            Task {
                await delegate?.didSelectRadioButton(title: data.title, value: data.selectedItem)
            }
            reloadRadioButtons(toggledButtonTag: sender.tag)
        }
    }
}

extension CommonRadioButtonTableViewCell: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.parent.layer.borderColor = theme.strokeBorder.cgColor
            self.parent.backgroundColor = theme.backgroundSecondary
            self.contentView.backgroundColor = theme.backgroundPrimary
            self.titleLabel.textColor = theme.textSecondary
        }
    }
}
