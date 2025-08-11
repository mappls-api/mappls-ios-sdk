//
//  PlacePickerChooseTypeViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 17/01/25.
//

import UIKit

class PlacePickerChooseTypeViewController: UIViewController {
    
    var navBarView: NavigationBarView!
    var defaultOpenBtn: UIButton!
    var settingsBtn: UIButton!
    var customOpenBtn: UIButton!
    var customMarkerEnabled: Bool = false
    var markerShadowEnabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        navBarView = NavigationBarView(title: SubOptionsEnum.placePickerView.rawValue)
        navBarView.addBottomShadow()
        navBarView.layer.zPosition = 3
        navBarView.delegate = self
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBarView)
        
        NSLayoutConstraint.activate([
            navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBarView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        settingsBtn = UIButton()
        settingsBtn.setImage(UIImage(systemName: "gearshape")?.withRenderingMode(.alwaysTemplate), for: .normal)
        settingsBtn.addTarget(self, action: #selector(self.openPlacePickerSettingsVC), for: .touchUpInside)
        settingsBtn.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(settingsBtn)
        
        NSLayoutConstraint.activate([
            settingsBtn.heightAnchor.constraint(equalToConstant: 40),
            settingsBtn.widthAnchor.constraint(equalToConstant: 40),
            settingsBtn.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            settingsBtn.trailingAnchor.constraint(equalTo: navBarView.trailingAnchor, constant: -15)
        ])
        
        defaultOpenBtn = UIButton()
        defaultOpenBtn.layer.borderWidth = 1
        defaultOpenBtn.setTitle("Default Place Picker", for: .normal)
        if #available(iOS 15.0, *) {
            defaultOpenBtn.configuration?.titleAlignment = .leading
        }
        defaultOpenBtn.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 17)
        defaultOpenBtn.addTarget(self, action: #selector(self.openDefaultPlacePicker), for: .touchUpInside)
        defaultOpenBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(defaultOpenBtn)
        
        NSLayoutConstraint.activate([
            defaultOpenBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            defaultOpenBtn.heightAnchor.constraint(equalToConstant: 50),
            defaultOpenBtn.topAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: 10),
            defaultOpenBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
        
        customOpenBtn = UIButton()
        customOpenBtn.layer.borderWidth = 1
        customOpenBtn.setTitle("Custom Place Picker", for: .normal)
        if #available(iOS 15.0, *) {
            customOpenBtn.configuration?.titleAlignment = .leading
        }
        customOpenBtn.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 17)
        customOpenBtn.addTarget(self, action: #selector(self.openCustomPlacePicker), for: .touchUpInside)
        customOpenBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customOpenBtn)
        
        NSLayoutConstraint.activate([
            customOpenBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            customOpenBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            customOpenBtn.topAnchor.constraint(equalTo: defaultOpenBtn.bottomAnchor, constant: 15),
            customOpenBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    @objc func openPlacePickerSettingsVC() {
        let vc = PlacePickerSettingsViewController()
        vc.isMarkerShadowViewHidden = !markerShadowEnabled
        vc.customMarkerIsOn = customMarkerEnabled
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openDefaultPlacePicker() {
        let vc = CustomWidgetsPlacePickerViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true)
    }
    
    @objc func openCustomPlacePicker() {
        let vc = CustomWidgetsPlacePickerViewController()
        if customMarkerEnabled {
            let marker = CustomUserLocationAnnotationView(reuseIdentifier: "CustomMarker")
            vc.customMarker = marker
        }
        vc.isMarkerShadowViewHidden = !markerShadowEnabled
        
        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true)
    }
}

extension PlacePickerChooseTypeViewController: PlacePickerSettingsDelegate {
    func customMarkerValueChanged(isOn: Bool) {
        customMarkerEnabled = isOn
    }
    
    func markerShadowViewHiddenValueChanged(isHidden: Bool) {
        markerShadowEnabled = !isHidden
    }
}

extension PlacePickerChooseTypeViewController: NavigationProtocol {
    func navigateBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PlacePickerChooseTypeViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
            self.defaultOpenBtn.backgroundColor = theme.backgroundSecondary
            self.settingsBtn.tintColor = theme.textPrimary
            self.customOpenBtn.backgroundColor = theme.backgroundSecondary
            self.defaultOpenBtn.layer.borderColor = theme.strokeBorder.cgColor
            self.customOpenBtn.layer.borderColor = theme.strokeBorder.cgColor
            self.defaultOpenBtn.setTitleColor(theme.textPrimary, for: .normal)
            self.customOpenBtn.setTitleColor(theme.textPrimary, for: .normal)
        }
    }
}
