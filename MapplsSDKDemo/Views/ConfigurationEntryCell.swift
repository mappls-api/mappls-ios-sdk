//
//  ConfigurationEntryCell.swift
//  MapplsSDKDemo
//
//  Created by rento on 29/01/25.
//

import UIKit

protocol ConfigurationEntryCellDelegate: Sendable, AnyObject {
    func saveBtnPressed(forTitle: String, values: [String]) async
    func searchLocBtnPressed() async
}

extension ConfigurationEntryCellDelegate {
    func searchLocBtnPressed() {}
}

class ConfigurationEntryCell: UITableViewCell {
    
    static let identifier: String = "ConfigurationEntryCell"
    
    weak var delegate: ConfigurationEntryCellDelegate?
    var titleLabel: UILabel!
    var inputStackView: UIStackView!
    var saveBtn: UIButton!
    var parent: UIView!
    var latInputField: UITextField?
    var longInputField: UITextField?
    var singleInputField: UITextField?
    var data: DrivingRangeKeyboardInput!
    
    convenience init(isLocCell: Bool) {
        self.init(frame: .zero)
    }
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    internal required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        selectionStyle = .none
        
        parent = UIView()
        parent.layer.cornerRadius = 6
        parent.layer.borderWidth = 1
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
        
        setInputStackView()
        
        saveBtn = UIButton(type: .system)
        saveBtn.layer.cornerRadius = 7
        saveBtn.layer.borderWidth = 1
        saveBtn.addTarget(self, action: #selector(self.saveBtnPressed), for: .touchUpInside)
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(saveBtn)
        
        NSLayoutConstraint.activate([
            saveBtn.topAnchor.constraint(equalTo: inputStackView.bottomAnchor, constant: 10),
            saveBtn.leadingAnchor.constraint(equalTo: inputStackView.leadingAnchor),
            saveBtn.trailingAnchor.constraint(equalTo: inputStackView.trailingAnchor),
            saveBtn.heightAnchor.constraint(equalToConstant: 40),
            saveBtn.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -15)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setInputStackView() {
        inputStackView = UIStackView()
        inputStackView.axis = .horizontal
        inputStackView.distribution = .fill
        inputStackView.alignment = .fill
        inputStackView.spacing = 10
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(inputStackView)
        
        NSLayoutConstraint.activate([
            inputStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            inputStackView.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -15),
            inputStackView.heightAnchor.constraint(equalToConstant: 42),
            inputStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6)
        ])
    }
    
    func setUpUIForSingleInputField() {
        setInputStackView()
        
        singleInputField = UITextField()
        singleInputField!.layer.cornerRadius = 5
        singleInputField!.layer.borderWidth = 1
        singleInputField!.text = data.inputs.indices.contains(0) ? data.inputs[0] : ""
        singleInputField!.delegate = self
        singleInputField!.leftView = UIView.init(frame: .init(x: 0, y: 0, width: 10, height: 10))
        singleInputField!.leftViewMode = .always
        singleInputField!.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        singleInputField!.layer.borderColor = ThemeColors.default.strokeBorder.cgColor
        singleInputField!.textColor = ThemeColors.default.textPrimary
        singleInputField!.backgroundColor = ThemeColors.default.backgroundSecondary
        singleInputField!.font = UIFont(name: "Roboto-Regular", size: 15)
        singleInputField!.layer.cornerRadius = 5
        singleInputField!.layer.borderWidth = 1
        singleInputField!.translatesAutoresizingMaskIntoConstraints = false
        inputStackView.addArrangedSubview(singleInputField!)
    }
    
    func setUpUIForMultipleInputField() {
        setInputStackView()
        
        let latLongInputStackView: UIStackView = UIStackView()
        latLongInputStackView.alignment = .fill
        latLongInputStackView.axis = .horizontal
        latLongInputStackView.spacing = 10
        latLongInputStackView.distribution = .fillEqually
        latLongInputStackView.translatesAutoresizingMaskIntoConstraints = false
        inputStackView.addArrangedSubview(latLongInputStackView)
        
        latInputField = UITextField()
        latInputField!.text = data.inputs.indices.contains(0) ? data.inputs[0] : ""
        latInputField!.textColor = ThemeColors.default.textPrimary
        latInputField!.backgroundColor = ThemeColors.default.backgroundSecondary
        latInputField!.font = UIFont(name: "Roboto-Regular", size: 15)
        latInputField!.layer.cornerRadius = 5
        latInputField!.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        latInputField!.leftView = .init(frame: .init(x: 0, y: 0, width: 10, height: 10))
        latInputField!.leftViewMode = .always
        latInputField!.layer.borderWidth = 1
        latInputField!.delegate = self
        latInputField!.layer.borderColor = ThemeColors.default.strokeBorder.cgColor
        latInputField!.translatesAutoresizingMaskIntoConstraints = false
        latLongInputStackView.addArrangedSubview(latInputField!)
        
        longInputField = UITextField()
        longInputField!.backgroundColor = ThemeColors.default.backgroundSecondary
        longInputField!.text = data.inputs.indices.contains(1) ? data.inputs[1] : ""
        longInputField!.textColor = ThemeColors.default.textPrimary
        longInputField!.font = UIFont(name: "Roboto-Regular", size: 15)
        longInputField!.layer.cornerRadius = 5
        longInputField!.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        longInputField!.delegate = self
        longInputField!.leftView = UIView.init(frame: .init(x: 0, y: 0, width: 10, height: 10))
        longInputField!.leftViewMode = .always
        longInputField!.layer.borderWidth = 1
        longInputField!.layer.borderColor = ThemeColors.default.strokeBorder.cgColor
        longInputField!.translatesAutoresizingMaskIntoConstraints = false
        latLongInputStackView.addArrangedSubview(longInputField!)
        
        let searchLocBtn: UIButton = UIButton()
        searchLocBtn.backgroundColor = ThemeColors.default.accentBrandPrimary
        searchLocBtn.layer.cornerRadius = 5
        searchLocBtn.setImage(UIImage(named: "search-icon"), for: .normal)
        searchLocBtn.addTarget(self, action: #selector(self.searchLocBtnPressed), for: .touchUpInside)
        searchLocBtn.translatesAutoresizingMaskIntoConstraints = false
        inputStackView.addArrangedSubview(searchLocBtn)
        
        NSLayoutConstraint.activate([
            searchLocBtn.heightAnchor.constraint(equalToConstant: 40),
            searchLocBtn.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func textFieldValueChanged(_ textField: UITextField) {
        if textField == singleInputField {
            data.inputs[0] = textField.text ?? ""
        }else if textField == latInputField {
            data.inputs[0] = textField.text ?? ""
        }else if textField == longInputField {
            data.inputs[1] = textField.text ?? ""
        }
    }
    
    func setUpData(input: DrivingRangeKeyboardInput) {
        self.data = input
        titleLabel.text = input.title
        saveBtn.setTitle(input.saveBtnTitle, for: .normal)
        saveBtn.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        
        if input.isLatLonInput {
            setUpUIForMultipleInputField()
        }else {
            setUpUIForSingleInputField()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        inputStackView.removeFromSuperview()
    }
    
    @objc func saveBtnPressed() {
        Task {
            await delegate?.saveBtnPressed(forTitle: data.title, values: data.isLatLonInput ? [latInputField!.text ?? "", longInputField!.text ?? ""] : [singleInputField!.text ?? ""])
        }
    }
    
    @objc func searchLocBtnPressed() {
        Task {
            await delegate?.searchLocBtnPressed()
        }
    }
}

extension ConfigurationEntryCell: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.parent.backgroundColor = theme.backgroundSecondary
            self.contentView.backgroundColor = theme.backgroundPrimary
            self.saveBtn.backgroundColor = theme.backgroundSecondary
            self.saveBtn.layer.borderColor = theme.accentBrandPrimary.cgColor
            self.parent.layer.borderColor = theme.strokeBorder.cgColor
            self.titleLabel.textColor = theme.textSecondary
            self.saveBtn.setTitleColor(theme.textPrimary, for: .normal)
        }
    }
}

extension ConfigurationEntryCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
