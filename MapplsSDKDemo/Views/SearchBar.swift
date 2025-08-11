//
//  HomeSearchBarViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 10/01/25.
//

import UIKit

class SearchBar: UIView {
    
    var searchField: UITextField!
    var searchIcon: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        layer.cornerRadius = 25
        layer.cornerCurve = .continuous
        addShadow(radius: 3, opacity: 1.0, offset: .init(width: 0, height: 4))
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate))
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(searchIcon)
        
        NSLayoutConstraint.activate([
            searchIcon.heightAnchor.constraint(equalToConstant: 30),
            searchIcon.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        stackView.setCustomSpacing(20, after: searchIcon)
        
        searchField = UITextField()
        searchField.placeholder = "Search destination..."
        searchField.font = .systemFont(ofSize: 19, weight: .medium)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(searchField)
        
        NSLayoutConstraint.activate([
            searchField.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
}

extension SearchBar: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.searchIcon.tintColor = theme.textPrimary
            self.backgroundColor = theme.backgroundSecondary
            self.layer.borderColor = theme.strokeBorder.cgColor
            self.searchField.textColor = theme.textPrimary
        }
    }
}
