//
//  PlacePickerSettingsViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 17/01/25.
//

protocol PlacePickerSettingsDelegate: Sendable, AnyObject {
    func customMarkerValueChanged(isOn: Bool) async
    func markerShadowViewHiddenValueChanged(isHidden: Bool) async
}

import UIKit

class PlacePickerSettingsViewController: UIViewController {
    
    var customMarkerIsOn: Bool = false
    var isMarkerShadowViewHidden = false
    var navBarView: NavigationBarView!
    var customMarkerLbl: UILabel!
    var customMarkerSwitch: UISwitch!
    var markerShadowViewHiddenLbl: UILabel!
    var markerShadowViewHiddenSwitch: UISwitch!
    weak var delegate: PlacePickerSettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        navBarView = NavigationBarView(title: "Settings")
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
        
        customMarkerLbl = UILabel()
        customMarkerLbl.text = "Custom Marker:"
        customMarkerLbl.font = UIFont(name: "Roboto-Regular", size: 16)
        customMarkerLbl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customMarkerLbl)
        
        NSLayoutConstraint.activate([
            customMarkerLbl.topAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: 20),
            customMarkerLbl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15)
        ])
        
        customMarkerSwitch = UISwitch()
        customMarkerSwitch.setOn(customMarkerIsOn, animated: true)
        customMarkerSwitch.addTarget(self, action: #selector(self.markerSliderClicked), for: .touchUpInside)
        customMarkerSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customMarkerSwitch)
        
        NSLayoutConstraint.activate([
            customMarkerSwitch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            customMarkerSwitch.heightAnchor.constraint(equalToConstant: 30),
            customMarkerSwitch.widthAnchor.constraint(equalToConstant: 60),
            customMarkerSwitch.centerYAnchor.constraint(equalTo: customMarkerLbl.centerYAnchor)
        ])
        
        markerShadowViewHiddenLbl = UILabel()
        markerShadowViewHiddenLbl.text = "Is Marker Shadow View Hidden:"
        markerShadowViewHiddenLbl.font = UIFont(name: "Roboto-Regular", size: 16)
        markerShadowViewHiddenLbl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(markerShadowViewHiddenLbl)
        
        NSLayoutConstraint.activate([
            markerShadowViewHiddenLbl.topAnchor.constraint(equalTo: customMarkerLbl.bottomAnchor, constant: 20),
            markerShadowViewHiddenLbl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15)
        ])
        
        markerShadowViewHiddenSwitch = UISwitch()
        markerShadowViewHiddenSwitch.setOn(isMarkerShadowViewHidden, animated: true)
        markerShadowViewHiddenSwitch.addTarget(self, action: #selector(self.markerShadowViewHiddenSliderClicked), for: .touchUpInside)
        markerShadowViewHiddenSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(markerShadowViewHiddenSwitch)
        
        NSLayoutConstraint.activate([
            markerShadowViewHiddenSwitch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            markerShadowViewHiddenSwitch.heightAnchor.constraint(equalToConstant: 30),
            markerShadowViewHiddenSwitch.widthAnchor.constraint(equalToConstant: 60),
            markerShadowViewHiddenSwitch.centerYAnchor.constraint(equalTo: markerShadowViewHiddenLbl.centerYAnchor)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    @objc func markerShadowViewHiddenSliderClicked() {
        Task {
            await delegate?.markerShadowViewHiddenValueChanged(isHidden: markerShadowViewHiddenSwitch.isOn)
        }
    }
    
    @objc func markerSliderClicked() {
        Task {
            await delegate?.customMarkerValueChanged(isOn: customMarkerSwitch.isOn)
        }
    }
}

extension PlacePickerSettingsViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
            self.customMarkerLbl.textColor = theme.textPrimary
            self.customMarkerSwitch.onTintColor = theme.accentBrandPrimary
            self.markerShadowViewHiddenLbl.textColor = theme.textPrimary
            self.markerShadowViewHiddenSwitch.onTintColor = theme.accentBrandPrimary
        }
    }
}

extension PlacePickerSettingsViewController: NavigationProtocol {
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}
