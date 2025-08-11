//
//  SubOptionsViewCell.swift
//  MapplsSDKDemo
//
//  Created by rento on 08/01/25.
//

import UIKit
import MapplsMap
import CoreLocation

class SubOptionsHashable: Hashable {
    let id: UUID
    var title: String
    var subTitle: String
    var icon: UIImage?
    
    init(title: String, subTitle: String, icon: UIImage?) {
        self.id = UUID()
        self.title = title
        self.subTitle = subTitle
        self.icon = icon
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: SubOptionsHashable, rhs: SubOptionsHashable) -> Bool {
        return lhs.id == rhs.id
    }
}

class SubOptionsViewCell: UICollectionViewCell {
    
    static let identifier: String = "SubOptionsViewCell"
    
    var mapView: MapplsMapView?
    var titleLbl: UILabel!
    var subTitleLbl: UILabel!
    var iconImgView: UIImageView!
    var mapImage: UIImageView?
    var titleLblLeadingConstraint: NSLayoutConstraint = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        self.addBottomShadow()
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.masksToBounds = true
        
        iconImgView = UIImageView()
        iconImgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImgView)
        
        NSLayoutConstraint.activate([
            iconImgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconImgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 180),
            iconImgView.heightAnchor.constraint(equalToConstant: 37),
            iconImgView.widthAnchor.constraint(equalToConstant: 37)
        ])
        
        titleLbl = UILabel()
        titleLbl.font = UIFont(name: "Roboto-Regular", size: 16)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLbl)
        
        titleLblLeadingConstraint = titleLbl.leadingAnchor.constraint(equalTo: iconImgView.trailingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([
            titleLblLeadingConstraint,
            titleLbl.topAnchor.constraint(equalTo: iconImgView.topAnchor)
        ])
        
        subTitleLbl = UILabel()
        subTitleLbl.numberOfLines = 0
        subTitleLbl.font = UIFont(name: "Roboto-Regular", size: 14)
        subTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subTitleLbl)
        
        NSLayoutConstraint.activate([
            subTitleLbl.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor),
            subTitleLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            subTitleLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            subTitleLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 1)
        ])
        
        //MARK: MapView
        mapView = MapplsMapView()
        mapView?.delegate = self
        mapView?.isHidden = true
        mapView?.showsUserLocation = true
        mapView?.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mapView!)
        
        NSLayoutConstraint.activate([
            mapView!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mapView!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mapView!.topAnchor.constraint(equalTo: contentView.topAnchor),
            mapView!.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        //MARK: MapImageView
        mapImage = UIImageView(image: UIImage(named: "map-snapshot"))
        mapImage?.isHidden = true
        mapImage?.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mapImage!)
        
        NSLayoutConstraint.activate([
            mapImage!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mapImage!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mapImage!.topAnchor.constraint(equalTo: contentView.topAnchor),
            mapImage!.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setUpMapView() {
        mapView?.isHidden = false
        mapImage?.isHidden = true
    }
    
    func setMapSnapshotImage() {
        mapImage?.isHidden = false
        mapView?.isHidden = true
    }
    
    func setData(data: SubOptionsHashable) {
        if let image = data.icon {
            iconImgView.image = image
        }else {
            iconImgView.isHidden = true
            titleLblLeadingConstraint.isActive = false
            titleLblLeadingConstraint = titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
            titleLblLeadingConstraint.isActive = true
        }
        titleLbl.text = data.title
        subTitleLbl.text = data.subTitle
    }
}

extension SubOptionsViewCell: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.contentView.backgroundColor = theme.backgroundSecondary
            self.contentView.layer.borderColor = theme.strokeBorder.cgColor
            self.titleLbl.textColor = theme.textPrimary
            self.subTitleLbl.textColor = theme.textSecondary
        }
    }
}

extension SubOptionsViewCell: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        mapView.setCamera(.init(lookingAtCenterMapplsPin: "mmi000", acrossDistance: 1000, pitch: mapView.camera.pitch, heading: mapView.camera.heading), animated: true)
        
        if titleLbl.text == SubOptionsEnum.mapTraffic.rawValue {
            mapView.isTrafficEnabled = true
            mapView.isClosureTrafficEnabled = true
            mapView.isFreeFlowTrafficEnabled = true
            mapView.isNonFreeFlowTrafficEnabled = true
            mapView.isStopIconTrafficEnabled = true
        }
    }
}
