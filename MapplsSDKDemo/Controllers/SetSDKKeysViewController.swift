//
//  SetSDKKeysViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 28/01/25.
//

import UIKit
import MapplsAPICore

class SetSDKKeysViewController: UIViewController {
    
    var titleBarView: TitleBarView!
    var sdkKeysSetView: SDKKeysSetView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        titleBarView = TitleBarView()
        titleBarView.addBottomShadow()
        titleBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleBarView)
        
        NSLayoutConstraint.activate([
            titleBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleBarView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        sdkKeysSetView = SDKKeysSetView()
        sdkKeysSetView.delegate = self
        sdkKeysSetView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sdkKeysSetView)
        
        NSLayoutConstraint.activate([
            sdkKeysSetView.topAnchor.constraint(equalTo: titleBarView.bottomAnchor, constant: 50),
            sdkKeysSetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            sdkKeysSetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            sdkKeysSetView.heightAnchor.constraint(equalToConstant: 345)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
}

extension SetSDKKeysViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
        }
    }
}

extension SetSDKKeysViewController: SDKKeysSubmitProtocol {
    func sdkKeyTextFieldChanged(text: String) {
        
    }
    
    func apiKeyTextFieldChanged(text: String) {
        
    }
    
    func clientIDTextFieldChanegd(text: String) {
        
    }
    
    func clientSecretTextFieldChanged(text: String) {
        
    }
    
    func didClickSubmit(keyVal: [String : String]) {
        guard keyVal.values.first(where: {$0 == ""})?.count != 0 else {
            let alertController = UIAlertController(title: "Error occured", message: "Please enter missing keys", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            
            present(alertController, animated: true)
            return
        }
        
        let vc = OptionsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
