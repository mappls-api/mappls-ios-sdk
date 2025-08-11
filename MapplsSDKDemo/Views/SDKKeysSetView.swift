//
//  SDKKeysSetView.swift
//  MapplsSDKDemo
//
//  Created by rento on 28/01/25.
//

import UIKit

protocol SDKKeysSubmitProtocol: Sendable, AnyObject {
    func didClickSubmit(keyVal: [String: String]) async
    func sdkKeyTextFieldChanged(text: String) async
    func apiKeyTextFieldChanged(text: String) async
    func clientIDTextFieldChanegd(text: String) async
    func clientSecretTextFieldChanged(text: String) async
}

class SDKKeysSetView: UIView {
    
    weak var delegate: SDKKeysSubmitProtocol?
    
    var sdkKeyInput: CommonInputCell!
    var apiKeyInput: CommonInputCell!
    var clientIDInput: CommonInputCell!
    var clientSecretInput: CommonInputCell!
    var submitBtn: UIButton!
    
    var sdkKeyValPairs: [String: String] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        sdkKeyInput = CommonInputCell()
        sdkKeyInput.setTitleLbl(title: "Map SDK Key")
        sdkKeyInput.setTFPlaceHolder(placeholder: "Enter SDK Key")
        sdkKeyInput.textField.delegate = self
        sdkKeyInput.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sdkKeyInput)
        
        NSLayoutConstraint.activate([
            sdkKeyInput.leadingAnchor.constraint(equalTo: leadingAnchor),
            sdkKeyInput.topAnchor.constraint(equalTo: topAnchor),
            sdkKeyInput.trailingAnchor.constraint(equalTo: trailingAnchor),
            sdkKeyInput.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        apiKeyInput = CommonInputCell()
        apiKeyInput.setTitleLbl(title: "RST API Key")
        apiKeyInput.setTFPlaceHolder(placeholder: "Enter API Key")
        apiKeyInput.textField.delegate = self
        apiKeyInput.translatesAutoresizingMaskIntoConstraints = false
        addSubview(apiKeyInput)
        
        NSLayoutConstraint.activate([
            apiKeyInput.leadingAnchor.constraint(equalTo: sdkKeyInput.leadingAnchor),
            apiKeyInput.topAnchor.constraint(equalTo: sdkKeyInput.bottomAnchor, constant: 15),
            apiKeyInput.trailingAnchor.constraint(equalTo: sdkKeyInput.trailingAnchor),
            apiKeyInput.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        clientIDInput = CommonInputCell()
        clientIDInput.setTitleLbl(title: "Client ID")
        clientIDInput.setTFPlaceHolder(placeholder: "Enter ID")
        clientIDInput.textField.delegate = self
        clientIDInput.translatesAutoresizingMaskIntoConstraints = false
        addSubview(clientIDInput)
        
        NSLayoutConstraint.activate([
            clientIDInput.leadingAnchor.constraint(equalTo: apiKeyInput.leadingAnchor),
            clientIDInput.topAnchor.constraint(equalTo: apiKeyInput.bottomAnchor, constant: 15),
            clientIDInput.trailingAnchor.constraint(equalTo: apiKeyInput.trailingAnchor),
            clientIDInput.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        clientSecretInput = CommonInputCell()
        clientSecretInput.setTitleLbl(title: "Client Secret")
        clientSecretInput.setTFPlaceHolder(placeholder: "Enter Secret")
        clientSecretInput.textField.delegate = self
        clientSecretInput.translatesAutoresizingMaskIntoConstraints = false
        addSubview(clientSecretInput)
        
        NSLayoutConstraint.activate([
            clientSecretInput.leadingAnchor.constraint(equalTo: clientIDInput.leadingAnchor),
            clientSecretInput.topAnchor.constraint(equalTo: clientIDInput.bottomAnchor, constant: 15),
            clientSecretInput.trailingAnchor.constraint(equalTo: clientIDInput.trailingAnchor),
            clientSecretInput.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        submitBtn = UIButton(type: .system)
        submitBtn.setTitle("Submit", for: .normal)
        submitBtn.addTarget(self, action: #selector(self.submitBtnChanged), for: .touchUpInside)
        submitBtn.layer.cornerRadius = 8
        submitBtn.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(submitBtn)
        
        NSLayoutConstraint.activate([
            submitBtn.leadingAnchor.constraint(equalTo: clientSecretInput.leadingAnchor),
            submitBtn.trailingAnchor.constraint(equalTo: clientSecretInput.trailingAnchor),
            submitBtn.bottomAnchor.constraint(equalTo: bottomAnchor),
            submitBtn.topAnchor.constraint(equalTo: clientSecretInput.bottomAnchor, constant: 15)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    @objc func submitBtnChanged() {
        Task {
            sdkKeyValPairs[Constants.sdkKey] = sdkKeyInput.textField.text ?? ""
            sdkKeyValPairs[Constants.restAPIKey] = apiKeyInput.textField.text ?? ""
            sdkKeyValPairs[Constants.clientIDKey] = clientIDInput.textField.text ?? ""
            sdkKeyValPairs[Constants.clientSecretKey] = clientSecretInput.textField.text ?? ""
            
            await delegate?.didClickSubmit(keyVal: sdkKeyValPairs)
        }
    }
}

extension SDKKeysSetView: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.backgroundColor = theme.backgroundPrimary
            self.submitBtn.backgroundColor = theme.accentBrandPrimary
            self.submitBtn.setTitleColor(theme.textPrimary, for: .normal)
        }
    }
}

extension SDKKeysSetView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        Task {
            if textField == sdkKeyInput.textField {
                sdkKeyValPairs[Constants.sdkKey] = textField.text ?? ""
                await delegate?.sdkKeyTextFieldChanged(text: textField.text ?? "")
            }else if textField == apiKeyInput.textField {
                sdkKeyValPairs[Constants.restAPIKey] = textField.text ?? ""
                await delegate?.apiKeyTextFieldChanged(text: textField.text ?? "")
            }else if textField == clientIDInput.textField {
                sdkKeyValPairs[Constants.clientIDKey] = textField.text ?? ""
                await delegate?.clientIDTextFieldChanegd(text: textField.text ?? "")
            }else if textField == clientSecretInput.textField {
                sdkKeyValPairs[Constants.clientSecretKey] = textField.text ?? ""
                await delegate?.clientSecretTextFieldChanged(text: textField.text ?? "")
            }
        }
    }
}
