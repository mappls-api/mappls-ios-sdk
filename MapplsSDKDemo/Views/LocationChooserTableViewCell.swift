//
//  LocationChooserTableViewCell.swift
//  MapplsSDKDemo
//
//  Created by rento on 27/01/25.
//

import UIKit

class LocationChooserTableViewCell: UITableViewCell {
    var sourceAutocompleteWidgetButton: UIButton!
    var destinationAutocompleteWidgetButton: UIButton!
    var viaAutocompleteWidgetButton: UIButton!
    var sourceLocationTextField = UITextField()
    var destinationLocationTextField = UITextField()
    var viaLocationTextField = UITextField()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func commonInit() {
        setupViews()
        setupConstraints()
        
//        sourceLocationTextField.isHidden = true
        destinationLocationTextField.isHidden = true
        viaLocationTextField.isHidden = true
        sourceAutocompleteWidgetButton.isHidden = true
        viaAutocompleteWidgetButton.isHidden = true
        viaLocationTextField.isHidden = true
        destinationAutocompleteWidgetButton.isHidden = true
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    func setupViews() {
        selectionStyle = .none
        sourceLocationTextField = UITextField()
        sourceLocationTextField.placeholder = ""
//        sourceLocationTextField.isHidden = true
        sourceLocationTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sourceLocationTextField)
        
        destinationLocationTextField = UITextField()
        destinationLocationTextField.placeholder = "Destination (Mappls Pin or cordinate in longitude, latitude)"
        destinationLocationTextField.isHidden = true
        destinationLocationTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(destinationLocationTextField)
        
        viaLocationTextField = UITextField()
        viaLocationTextField.placeholder = "Via (Mappls Pin or cordinate in longitude, latitude)"
        viaLocationTextField.isHidden = true
        viaLocationTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viaLocationTextField)
        
        sourceAutocompleteWidgetButton = UIButton()
        sourceAutocompleteWidgetButton.setTitle("", for: .normal)
        sourceAutocompleteWidgetButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sourceAutocompleteWidgetButton)
        
        destinationAutocompleteWidgetButton = UIButton()
        destinationAutocompleteWidgetButton.setTitle("", for: .normal)
        destinationAutocompleteWidgetButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(destinationAutocompleteWidgetButton)
        
        viaAutocompleteWidgetButton = UIButton()
        viaAutocompleteWidgetButton.setTitle("", for: .normal)
        viaAutocompleteWidgetButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viaAutocompleteWidgetButton)
    }
    
    func setupConstraints() {
        sourceLocationTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        sourceLocationTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        sourceLocationTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        sourceLocationTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        
        destinationLocationTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        destinationLocationTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        destinationLocationTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        destinationLocationTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        
        viaLocationTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        viaLocationTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        viaLocationTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        viaLocationTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        
        sourceAutocompleteWidgetButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        sourceAutocompleteWidgetButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        sourceAutocompleteWidgetButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        sourceAutocompleteWidgetButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        
        destinationAutocompleteWidgetButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        destinationAutocompleteWidgetButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        destinationAutocompleteWidgetButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        destinationAutocompleteWidgetButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        
        viaAutocompleteWidgetButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        viaAutocompleteWidgetButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        viaAutocompleteWidgetButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        viaAutocompleteWidgetButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension LocationChooserTableViewCell: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.contentView.backgroundColor = theme.backgroundPrimary
            self.sourceLocationTextField.textColor = theme.textPrimary
            self.sourceAutocompleteWidgetButton.setTitleColor(theme.textPrimary, for: .normal)
            self.destinationAutocompleteWidgetButton.setTitleColor(theme.textPrimary, for: .normal)
            self.viaAutocompleteWidgetButton.setTitleColor(theme.textPrimary, for: .normal)
            self.viaLocationTextField.textColor = theme.textPrimary
            self.destinationLocationTextField.textColor = theme.textPrimary
        }
    }
}
