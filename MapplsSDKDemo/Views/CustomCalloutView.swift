//
//  CustomCalloutView.swift
//  MapplsSDKDemo
//
//  Created by rento on 16/01/25.
//

import UIKit
import MapplsMap

class CustomCalloutView: UIView, MGLCalloutView {
    var representedObject: MGLAnnotation
    
    let dismissesAutomatically: Bool = false
    let isAnchoredToAnnotation: Bool = true
    var minusButton: UIButton!
    var plusButton: UIButton!
    var infoView: UIView!
    var zoomLevelLbl: UILabel!
    
    override var center: CGPoint {
        set {
            var newCenter = newValue
            newCenter.y = newCenter.y - bounds.midY
            super.center = newCenter
        }
        get {
            return super.center
        }
    }
    
    lazy var leftAccessoryView = UIView()
    lazy var rightAccessoryView = UIView()
    
    weak var delegate: MGLCalloutViewDelegate?
    
    let tipHeight: CGFloat = 10.0
    let tipWidth: CGFloat = 20.0
    
    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        super.init(frame: .zero)
        backgroundColor = .clear
        setUpUI()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        let stack = UIStackView()
        stack.backgroundColor = .clear
        stack.spacing = 15
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.addShadow(radius: 2, opacity: 0.5, offset: .init(width: 0, height: 2))
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        minusButton = UIButton(type: .system)
        minusButton.setImage(UIImage(systemName: "minus"), for: .normal)
        minusButton.layer.cornerRadius = 20
        minusButton.addTarget(self, action: #selector(self.zoomInOutDismiss), for: .touchUpInside)
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(minusButton)
        NSLayoutConstraint.activate([
            minusButton.heightAnchor.constraint(equalToConstant: 40),
            minusButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        plusButton = UIButton(type: .system)
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.layer.cornerRadius = 20
        plusButton.addTarget(self, action: #selector(self.zoomInOutDismiss), for: .touchUpInside)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(plusButton)
        NSLayoutConstraint.activate([
            plusButton.heightAnchor.constraint(equalToConstant: 40),
            plusButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.heightAnchor.constraint(equalToConstant: 40),
            stack.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        infoView = UIView()
        infoView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(infoView)
        
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            infoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            infoView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            infoView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: -15)
        ])
        
        let iconImgeView = UIImageView(image: UIImage(named: "3d-map-pin"))
        iconImgeView.backgroundColor = .clear
        iconImgeView.contentMode = .scaleAspectFit
        iconImgeView.addShadow(radius: 3, opacity: 1.0, offset: .init(width: 0, height: 8))
        iconImgeView.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(iconImgeView)
        
        NSLayoutConstraint.activate([
            iconImgeView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 10),
            iconImgeView.heightAnchor.constraint(equalToConstant: 40),
            iconImgeView.widthAnchor.constraint(equalToConstant: 40),
            iconImgeView.centerYAnchor.constraint(equalTo: infoView.centerYAnchor, constant: 5)
        ])
        
        zoomLevelLbl = UILabel()
        zoomLevelLbl.text = "Set zoom level"
        zoomLevelLbl.numberOfLines = 0
        zoomLevelLbl.textAlignment = .center
        zoomLevelLbl.font = UIFont(name: "Roboto-Regular", size: 15)
        zoomLevelLbl.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(zoomLevelLbl)
        
        NSLayoutConstraint.activate([
            zoomLevelLbl.leadingAnchor.constraint(equalTo: iconImgeView.trailingAnchor, constant: 5),
            zoomLevelLbl.centerYAnchor.constraint(equalTo: iconImgeView.centerYAnchor),
            zoomLevelLbl.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -5)
        ])
    }
    
    @objc func zoomInOutDismiss() {
        self.dismissCallout(animated: true)
    }
    
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedRect: CGRect, animated: Bool) {
        view.addSubview(self)
        
        let frameWidth: CGFloat = 140
        let frameHeight: CGFloat = 120 + tipHeight
        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
        let frameOriginY = rect.origin.y - frameHeight
        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)
        
        if animated {
            alpha = 0
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.alpha = 1
            }
        }
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(
            arcCenter: CGPoint(x: infoView.bounds.minX + 20, y: infoView.bounds.minY),
            radius: 20,
            startAngle: .pi,
            endAngle: .pi / 2,
            clockwise: false
        )
        path.addArc(
            withCenter: CGPoint(x: infoView.bounds.maxX - 20, y: infoView.bounds.minY),
            radius: 20,
            startAngle: .pi / 2,
            endAngle: 0,
            clockwise: false
        )
        path.addLine(to: CGPoint(x: infoView.bounds.maxX, y: infoView.bounds.maxY))
        path.addLine(to: CGPoint(x: infoView.bounds.minX, y: infoView.bounds.maxY))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        infoView.layer.mask = shapeLayer
    }
    
    func dismissCallout(animated: Bool) {
        if (superview != nil) {
            if animated {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.alpha = 0
                    }, completion: { [weak self] _ in
                        self?.removeFromSuperview()
                })
            } else {
                removeFromSuperview()
            }
        }
    }
    
    // MARK: - Callout interaction handlers
    
    func isCalloutTappable() -> Bool {
        if let delegate = delegate {
            if delegate.responds(to: #selector(MGLCalloutViewDelegate.calloutViewShouldHighlight)) {
                return delegate.calloutViewShouldHighlight!(self)
            }
        }
        return false
    }
    
    @objc func calloutTapped() {
        if isCalloutTappable() && delegate!.responds(to: #selector(MGLCalloutViewDelegate.calloutViewTapped)) {
            delegate!.calloutViewTapped!(self)
        }
    }
    
    // MARK: - Custom view styling
    
    override func draw(_ rect: CGRect) {
        let fillColor : UIColor = ThemeColors.default.backgroundPrimary
        
        let tipLeft = rect.origin.x + (rect.size.width / 2.0) - (tipWidth / 2.0)
        let tipBottom = CGPoint(x: rect.origin.x + (rect.size.width / 2.0), y: rect.origin.y + rect.size.height)
        let heightWithoutTip = rect.size.height - tipHeight - 1
        
        let currentContext = UIGraphicsGetCurrentContext()!
        
        let tipPath = CGMutablePath()
        tipPath.move(to: CGPoint(x: tipLeft, y: heightWithoutTip))
        tipPath.addLine(to: CGPoint(x: tipBottom.x, y: tipBottom.y))
        tipPath.addLine(to: CGPoint(x: tipLeft + tipWidth, y: heightWithoutTip))
        tipPath.closeSubpath()
        
        fillColor.setFill()
        currentContext.addPath(tipPath)
        currentContext.fillPath()
    }
}

extension CustomCalloutView: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.minusButton.backgroundColor = theme.backgroundSecondary
            self.plusButton.backgroundColor = theme.backgroundSecondary
            self.minusButton.setTitleColor(theme.textPrimary, for: .normal)
            self.plusButton.setTitleColor(theme.textPrimary, for: .normal)
            self.infoView.backgroundColor = theme.backgroundPrimary
            self.zoomLevelLbl.textColor = theme.textPrimary
        }
    }
}


