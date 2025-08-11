//
//  StyleImageIcon.swift
//  MapplsSDKDemo
//
//  Created by Robin on 13/03/25.
//

import UIKit
import MapplsMap

class StyleImageIconView: MGLAnnotationView {
    
    var imageView: UIImageView!
    var moneyLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        frame = CGRect(x: 0, y: 0, width: 170, height: 50)
        layer.cornerRadius = 15
        layer.cornerCurve = .continuous
        backgroundColor = .red
        
        imageView = UIImageView()
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.backgroundColor = .red
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            imageView.heightAnchor.constraint(equalToConstant: 35),
            imageView.widthAnchor.constraint(equalToConstant: 35),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        moneyLbl = UILabel()
        moneyLbl.layer.masksToBounds = true
        moneyLbl.textColor = .white
        moneyLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(moneyLbl)
        
        NSLayoutConstraint.activate([
            moneyLbl.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            moneyLbl.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            moneyLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            moneyLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.bounds.width/2
    }
}
