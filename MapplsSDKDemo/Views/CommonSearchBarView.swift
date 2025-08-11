//
//  SearchSuboptionsView.swift
//  MapplsSDKDemo
//
//  Created by Siddhartha Kushwaha on 13/02/25.
//

import UIKit

protocol CommonSearchBarDelegate: Sendable, AnyObject {
    func searchDidChange(text: String) async
    func didPressDone(text: String) async
}

extension CommonSearchBarDelegate {
    func didPressDone(text: String) async {}
}

class CommonSearchBarView: UIView {
    
    var textField: UITextField!
    var searchIcon: UIImageView!
    weak var delegate: CommonSearchBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        layer.borderWidth = 1
        
        textField = UITextField()
        textField.placeholder = "Search..."
        textField.addTarget(self, action: #selector(self.searchFieldTextDidChange), for: .editingChanged)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.leftView = .init(frame: .init(x: 0, y: 0, width: 60, height: 0))
        textField.delegate = self
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        searchIcon = UIImageView(image: UIImage(named: "search-icon")!.withRenderingMode(.alwaysTemplate))
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        textField.addSubview(searchIcon)
        
        NSLayoutConstraint.activate([
            searchIcon.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 15),
            searchIcon.heightAnchor.constraint(equalToConstant: 25),
            searchIcon.widthAnchor.constraint(equalToConstant: 25),
            searchIcon.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setSearchText(placeholder: String) {
        textField.placeholder = placeholder
    }
    
    @objc func searchFieldTextDidChange() {
        Task {
            await delegate?.searchDidChange(text: textField.text ?? "")
        }
    }
}

extension CommonSearchBarView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Task {
            await delegate?.didPressDone(text: textField.text ?? "")
        }
        textField.resignFirstResponder()
        return true
    }
}

extension CommonSearchBarView: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.layer.borderColor = theme.strokeBorder.cgColor
            self.backgroundColor = theme.backgroundSecondary
            self.textField.layer.borderColor = theme.strokeBorder.cgColor
            self.textField.backgroundColor = theme.backgroundPrimary
            self.searchIcon.tintColor = theme.textSecondary
        }
    }
}
