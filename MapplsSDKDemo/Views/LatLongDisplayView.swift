//
//  LatLongDisplayView.swift
//  MapplsSDKDemo
//
//  Created by rento on 09/01/25.
//

import UIKit

class LatLongDisplayToast: UIView {
    
    var latLongLbl: UILabel!
    var isAnimating: Bool = false
    var delayTime: TimeInterval = 2.0
    private var disappearTimer: Timer?
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        layer.cornerRadius = 10
        transform = CGAffineTransformMakeScale(0.5, 0.5)
        layer.opacity = 0.0
        
        latLongLbl = UILabel()
        latLongLbl.font = UIFont(name: "Roboto-Regular", size: 14)
        latLongLbl.numberOfLines = 0
        latLongLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(latLongLbl)
        
        NSLayoutConstraint.activate([
            latLongLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            latLongLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            latLongLbl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setLatLong(lat: Double, long: Double, altitude: CGFloat, isOnMove: Bool) {
        latLongLbl.text = "\(isOnMove ? "onMove: " : "")LatLng [latitude=\(lat), longitude=\(long), altitude=\(altitude)]"
    }
    
    func appear() {
        disappearTimer?.invalidate()
        
        if isAnimating {
            scheduleDisappear()
            return
        }
        
        showToast()
    }
    
    private func showToast() {
        isHidden = false
        isAnimating = true
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.layer.opacity = 1.0
        } completion: { _ in
            self.scheduleDisappear()
        }
    }
    
    private func scheduleDisappear() {
        disappearTimer = Timer.scheduledTimer(withTimeInterval: delayTime, repeats: false) { [weak self] _ in
            self?.hideToast()
        }
    }
    
    private func hideToast() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut]) {
            self.transform = CGAffineTransformMakeScale(0.5, 0.5)
            self.layer.opacity = 0.0
        } completion: { _ in
            self.isAnimating = false
            self.isHidden = true
        }
    }
}

extension LatLongDisplayToast: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.backgroundColor = theme.backgroundPrimary
            self.latLongLbl.textColor = theme.textPrimary
        }
    }
}
