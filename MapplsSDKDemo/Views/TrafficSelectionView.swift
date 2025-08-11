//
//  TrafficSelectionView.swift
//  MapplsSDKDemo
//
//  Created by rento on 08/01/25.
//

import UIKit

protocol TrafficSelectionProtocol: Sendable, AnyObject {
    func showTraffic(enabled: Bool) async
    func showFreeFlow(enabled: Bool) async
    func showNonFreeFlow(enabled: Bool) async
    func showClosure(enabled: Bool) async
    func showStopIcon(enabled: Bool) async
}

class TrafficSelectionView: UIView {
    
    weak var delegate: TrafficSelectionProtocol?
    
    var showTrafficLbl: UILabel!
    var trafficToggle: UISwitch!
    var freeFlowSelectorBtn: UIButton!
    var nonFreeFlowSelectorBtn: UIButton!
    var showClosureBtn: UIButton!
    var showStopIconBtn: UIButton!
    var freeFlowLbl: UILabel!
    var nonFreeFlowLbl: UILabel!
    var showClosureLbl: UILabel!
    var showStopIconLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        layer.cornerRadius = 12
        
        showTrafficLbl = UILabel()
        showTrafficLbl.text = "Show Traffic"
        showTrafficLbl.font = UIFont(name: "Roboto-Regular", size: 16)
        showTrafficLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(showTrafficLbl)
        
        NSLayoutConstraint.activate([
            showTrafficLbl.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            showTrafficLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14)
        ])
        
        trafficToggle = UISwitch()
        trafficToggle.transform = CGAffineTransformMakeScale(0.5, 0.5)
        trafficToggle.addTarget(self, action: #selector(self.trafficToggleClicked(_:)), for: .valueChanged)
        trafficToggle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trafficToggle)
        
        NSLayoutConstraint.activate([
            trafficToggle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            trafficToggle.centerYAnchor.constraint(equalTo: showTrafficLbl.centerYAnchor),
            trafficToggle.heightAnchor.constraint(equalToConstant: 25),
            trafficToggle.widthAnchor.constraint(equalToConstant: 35)
        ])
        
        freeFlowSelectorBtn = UIButton()
        freeFlowSelectorBtn.setImage(UIImage(named: "not-selected"), for: .normal)
        freeFlowSelectorBtn.isSelected = false
        freeFlowSelectorBtn.addTarget(self, action: #selector(self.freeFlowSelectorBtnClicked(_:)), for: .touchUpInside)
        freeFlowSelectorBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(freeFlowSelectorBtn)
        
        NSLayoutConstraint.activate([
            freeFlowSelectorBtn.leadingAnchor.constraint(equalTo: showTrafficLbl.leadingAnchor),
            freeFlowSelectorBtn.heightAnchor.constraint(equalToConstant: 24),
            freeFlowSelectorBtn.widthAnchor.constraint(equalToConstant: 24),
            freeFlowSelectorBtn.topAnchor.constraint(equalTo: trafficToggle.bottomAnchor, constant: 10)
        ])
        
        freeFlowLbl = UILabel()
        freeFlowLbl.text = "Free Flow"
        freeFlowLbl.font = UIFont(name: "Roboto-Regular", size: 16)
        freeFlowLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(freeFlowLbl)
        
        NSLayoutConstraint.activate([
            freeFlowLbl.leadingAnchor.constraint(equalTo: freeFlowSelectorBtn.trailingAnchor, constant: 7),
            freeFlowLbl.centerYAnchor.constraint(equalTo: freeFlowSelectorBtn.centerYAnchor)
        ])
        
        nonFreeFlowSelectorBtn = UIButton()
        nonFreeFlowSelectorBtn.setImage(UIImage(named: "not-selected"), for: .normal)
        nonFreeFlowSelectorBtn.isSelected = false
        nonFreeFlowSelectorBtn.addTarget(self, action: #selector(self.nonFreeFlowSelectorBtnClicked(_:)), for: .touchUpInside)
        nonFreeFlowSelectorBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nonFreeFlowSelectorBtn)
        
        NSLayoutConstraint.activate([
            nonFreeFlowSelectorBtn.leadingAnchor.constraint(equalTo: freeFlowSelectorBtn.leadingAnchor),
            nonFreeFlowSelectorBtn.heightAnchor.constraint(equalToConstant: 24),
            nonFreeFlowSelectorBtn.widthAnchor.constraint(equalToConstant: 24),
            nonFreeFlowSelectorBtn.topAnchor.constraint(equalTo: freeFlowSelectorBtn.bottomAnchor, constant: 10)
        ])
        
        nonFreeFlowLbl = UILabel()
        nonFreeFlowLbl.text = "Non Free Flow"
        nonFreeFlowLbl.font = UIFont(name: "Roboto-Regular", size: 16)
        nonFreeFlowLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nonFreeFlowLbl)
        
        NSLayoutConstraint.activate([
            nonFreeFlowLbl.leadingAnchor.constraint(equalTo: nonFreeFlowSelectorBtn.trailingAnchor, constant: 7),
            nonFreeFlowLbl.centerYAnchor.constraint(equalTo: nonFreeFlowSelectorBtn.centerYAnchor)
        ])
        
        showClosureBtn = UIButton()
        showClosureBtn.setImage(UIImage(named: "not-selected"), for: .normal)
        showClosureBtn.isSelected = false
        showClosureBtn.addTarget(self, action: #selector(self.showClosureSelectorBtnClicked(_:)), for: .touchUpInside)
        showClosureBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(showClosureBtn)
        
        NSLayoutConstraint.activate([
            showClosureBtn.leadingAnchor.constraint(equalTo: nonFreeFlowSelectorBtn.leadingAnchor),
            showClosureBtn.heightAnchor.constraint(equalToConstant: 24),
            showClosureBtn.widthAnchor.constraint(equalToConstant: 24),
            showClosureBtn.topAnchor.constraint(equalTo: nonFreeFlowSelectorBtn.bottomAnchor, constant: 10)
        ])
        
        showClosureLbl = UILabel()
        showClosureLbl.text = "Show Closure"
        showClosureLbl.font = UIFont(name: "Roboto-Regular", size: 16)
        showClosureLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(showClosureLbl)
        
        NSLayoutConstraint.activate([
            showClosureLbl.leadingAnchor.constraint(equalTo: showClosureBtn.trailingAnchor, constant: 7),
            showClosureLbl.centerYAnchor.constraint(equalTo: showClosureBtn.centerYAnchor)
        ])
        
        showStopIconBtn = UIButton()
        showStopIconBtn.setImage(UIImage(named: "not-selected"), for: .normal)
        showStopIconBtn.isSelected = false
        showStopIconBtn.addTarget(self, action: #selector(self.showStopIconSelectorBtnClicked(_:)), for: .touchUpInside)
        showStopIconBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(showStopIconBtn)
        
        NSLayoutConstraint.activate([
            showStopIconBtn.leadingAnchor.constraint(equalTo: showClosureBtn.leadingAnchor),
            showStopIconBtn.heightAnchor.constraint(equalToConstant: 24),
            showStopIconBtn.widthAnchor.constraint(equalToConstant: 24),
            showStopIconBtn.topAnchor.constraint(equalTo: showClosureBtn.bottomAnchor, constant: 10)
        ])
        
        showStopIconLbl = UILabel()
        showStopIconLbl.text = "Show Stop Icon"
        showStopIconLbl.font = UIFont(name: "Roboto-Regular", size: 16)
        showStopIconLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(showStopIconLbl)
        
        NSLayoutConstraint.activate([
            showStopIconLbl.leadingAnchor.constraint(equalTo: showStopIconBtn.trailingAnchor, constant: 7),
            showStopIconLbl.centerYAnchor.constraint(equalTo: showStopIconBtn.centerYAnchor)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    @objc func nonFreeFlowSelectorBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        Task {
            await delegate?.showNonFreeFlow(enabled: sender.isSelected)
        }
        nonFreeFlowLbl.textColor = sender.isSelected ? ThemeColors.default.textPrimary : ThemeColors.default.textSecondary
        sender.setImage(UIImage(named: sender.isSelected ? "selected" : "not-selected"), for: .normal)
    }
    
    @objc func freeFlowSelectorBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        Task {
            await delegate?.showFreeFlow(enabled: sender.isSelected)
        }
        freeFlowLbl.textColor = sender.isSelected ? ThemeColors.default.textPrimary : ThemeColors.default.textSecondary
        sender.setImage(UIImage(named: sender.isSelected ? "selected" : "not-selected"), for: .normal)
    }
    
    @objc func showClosureSelectorBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        Task {
            await delegate?.showClosure(enabled: sender.isSelected)
        }
        showClosureLbl.textColor = sender.isSelected ? ThemeColors.default.textPrimary : ThemeColors.default.textSecondary
        sender.setImage(UIImage(named: sender.isSelected ? "selected" : "not-selected"), for: .normal)
    }
    
    @objc func showStopIconSelectorBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        Task {
            await delegate?.showStopIcon(enabled: sender.isSelected)
        }
        showStopIconLbl.textColor = sender.isSelected ? ThemeColors.default.textPrimary : ThemeColors.default.textSecondary
        sender.setImage(UIImage(named: sender.isSelected ? "selected" : "not-selected"), for: .normal)
    }
    
    @objc func trafficToggleClicked(_ sender: UISwitch) {
        Task {
            await delegate?.showTraffic(enabled: sender.isOn)
        }
        showTrafficLbl.textColor = sender.isOn ? ThemeColors.default.textPrimary : ThemeColors.default.textSecondary
    }
}

extension TrafficSelectionView: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.backgroundColor = theme.backgroundPrimary.withAlphaComponent(0.95)
            self.showTrafficLbl.textColor = theme.textSecondary
            self.trafficToggle.onTintColor = theme.accentBrandPrimary
            self.freeFlowLbl.textColor = theme.textSecondary
            self.nonFreeFlowLbl.textColor = theme.textSecondary
            self.showClosureLbl.textColor = theme.textSecondary
            self.showStopIconLbl.textColor = theme.textSecondary
        }
    }
}
