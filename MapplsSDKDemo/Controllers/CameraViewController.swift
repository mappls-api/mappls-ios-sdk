//
//  CameraViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 10/01/25.
//

import UIKit
import MapplsMap
import FittedSheets

class CameraViewController: UIViewController {
    
    var cameraSubOptionSelected: SubOptionsEnum!
    var navBarView: NavigationBarView!
    var mapView: MapplsMapView!
    var mapCenterBtn: UIButton!
    var bottomBgView: UIView?
    var moveBtn: UIButton?
    var easeBtn: UIButton?
    var animateBtn: UIButton?
    var bottomSafeAreaInset: CGFloat = 0
    var landscapeSafeAreaInset: CGFloat = 0
    var landscapeHeightConstraints: [NSLayoutConstraint] = []
    var portraitConstraints: [NSLayoutConstraint] = []
    var mapCenterBtnBtmCons: NSLayoutConstraint!
    var modeSelectionBtn: UIButton?
    var modeLbl: UILabel?
    var trackingLbl: UILabel?
    var trackingSelectionButton: UIButton?
    var sheet: SheetViewController?
    var currentSelectedMode: CameraMode = .normal {
        didSet {
            let modeSelectionTitle = "\(currentSelectedMode.rawValue)         "
            modeSelectionBtn!.setTitle(String(modeSelectionTitle.prefix(14)), for: .normal)
        }
    }
    var currentSelectedTrackingType: CameraTrackingType = .none {
        didSet {
            let trackingTypeTitle = "\(currentSelectedTrackingType.abbreviated)           "
            trackingSelectionButton!.setTitle(String(trackingTypeTitle.prefix(14)), for: .normal)
        }
    }
    var cameraFeatureUsingMapplsPin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        bottomSafeAreaInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
        
        navBarView = NavigationBarView(title: cameraSubOptionSelected.rawValue)
        navBarView.addBottomShadow()
        navBarView.delegate = self
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBarView)
        
        NSLayoutConstraint.activate([
            navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBarView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        mapView = MapplsMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(mapView, belowSubview: navBarView)
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        mapCenterBtn = UIButton()
        mapCenterBtn.backgroundColor = .Colors.pureWhite
        mapCenterBtn.setImage(UIImage(named: "map-center-icon"), for: .normal)
        mapCenterBtn.addTarget(self, action: #selector(self.centerMap), for: .touchUpInside)
        mapCenterBtn.layer.cornerRadius = 25
        mapCenterBtn.addShadow(radius: 3, opacity: 0.5, offset: .init(width: 0, height: 4))
        mapCenterBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapCenterBtn)
        
        mapCenterBtnBtmCons = mapCenterBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        
        NSLayoutConstraint.activate([
            mapCenterBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mapCenterBtn.heightAnchor.constraint(equalToConstant: 50),
            mapCenterBtn.widthAnchor.constraint(equalToConstant: 50),
            mapCenterBtnBtmCons
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    @objc func centerMap() {
        if let userLocation = mapView.userLocation {
            mapView.setCenter(userLocation.coordinate, zoomLevel: 18, animated: true)
        }
    }
    
    func setCameraFeaturesView() {
        bottomBgView = UIView()
        bottomBgView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBgView!)
        
        portraitConstraints.append(bottomBgView!.heightAnchor.constraint(equalToConstant: 65 + bottomSafeAreaInset))
        landscapeHeightConstraints.append(bottomBgView!.heightAnchor.constraint(equalToConstant: 75))
        
        NSLayoutConstraint.activate([
            bottomBgView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBgView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBgView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.activate(portraitConstraints)
        }else {
            NSLayoutConstraint.activate(landscapeHeightConstraints)
        }
        
        mapCenterBtnBtmCons.isActive = false
        mapCenterBtnBtmCons = mapCenterBtn.bottomAnchor.constraint(equalTo: bottomBgView!.topAnchor, constant: -30)
        mapCenterBtnBtmCons.isActive = true
        
        easeBtn = UIButton(type: .system)
        easeBtn?.setTitle("Ease", for: .normal)
        easeBtn?.layer.borderWidth = 2
        easeBtn?.layer.cornerRadius = 20
        easeBtn?.addTarget(self, action: #selector(self.easeBtnPressed(_:)), for: .touchUpInside)
        easeBtn?.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        easeBtn?.translatesAutoresizingMaskIntoConstraints = false
        bottomBgView!.addSubview(easeBtn!)
        
        NSLayoutConstraint.activate([
            easeBtn!.heightAnchor.constraint(equalToConstant: 40),
            easeBtn!.widthAnchor.constraint(equalToConstant: 68),
            easeBtn!.centerYAnchor.constraint(equalTo: bottomBgView!.safeAreaLayoutGuide.centerYAnchor),
            easeBtn!.centerXAnchor.constraint(equalTo: bottomBgView!.centerXAnchor)
        ])
        
        moveBtn = UIButton(type: .system)
        moveBtn?.setTitle("Move", for: .normal)
        moveBtn?.layer.cornerRadius = 20
        moveBtn?.layer.borderWidth = 2
        moveBtn?.addTarget(self, action: #selector(self.moveBtnPressed(_:)), for: .touchUpInside)
        moveBtn?.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 16)
        moveBtn?.translatesAutoresizingMaskIntoConstraints = false
        bottomBgView!.addSubview(moveBtn!)
        
        NSLayoutConstraint.activate([
            moveBtn!.trailingAnchor.constraint(equalTo: easeBtn!.leadingAnchor, constant: -15),
            moveBtn!.heightAnchor.constraint(equalToConstant: 40),
            moveBtn!.widthAnchor.constraint(equalToConstant: 73),
            moveBtn!.centerYAnchor.constraint(equalTo: bottomBgView!.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        animateBtn = UIButton(type: .system)
        animateBtn?.setTitle("Animate", for: .normal)
        animateBtn?.layer.cornerRadius = 20
        animateBtn?.layer.borderWidth = 2
        animateBtn?.addTarget(self, action: #selector(self.animateBtnPressed(_:)), for: .touchUpInside)
        animateBtn?.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        animateBtn?.translatesAutoresizingMaskIntoConstraints = false
        bottomBgView!.addSubview(animateBtn!)
        
        NSLayoutConstraint.activate([
            animateBtn!.heightAnchor.constraint(equalToConstant: 40),
            animateBtn!.widthAnchor.constraint(equalToConstant: 93),
            animateBtn!.leadingAnchor.constraint(equalTo: easeBtn!.trailingAnchor, constant: 15),
            animateBtn!.centerYAnchor.constraint(equalTo: bottomBgView!.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func moveBtnSelectionChange(isSelected: Bool) {
        if isSelected {
            moveBtn!.layer.borderColor = ThemeColors.default.accentBrandPrimary.cgColor
            moveBtn?.setTitleColor(ThemeColors.default.accentBrandPrimary, for: .normal)
        }else {
            moveBtn!.layer.borderColor = ThemeColors.default.textSecondary.cgColor
            moveBtn?.setTitleColor(ThemeColors.default.textPrimary, for: .normal)
        }
    }
    
    func easeBtnSelectionChange(isSelected: Bool) {
        if isSelected {
            easeBtn!.layer.borderColor = ThemeColors.default.accentBrandPrimary.cgColor
            easeBtn?.setTitleColor(ThemeColors.default.accentBrandPrimary, for: .normal)
        }else {
            easeBtn!.layer.borderColor = ThemeColors.default.textSecondary.cgColor
            easeBtn?.setTitleColor(ThemeColors.default.textPrimary, for: .normal)
        }
    }
    
    func animateBtnSelectionChange(isSelected: Bool) {
        if isSelected {
            animateBtn!.layer.borderColor = ThemeColors.default.accentBrandPrimary.cgColor
            animateBtn?.setTitleColor(ThemeColors.default.accentBrandPrimary, for: .normal)
        }else {
            animateBtn!.layer.borderColor = ThemeColors.default.textSecondary.cgColor
            animateBtn?.setTitleColor(ThemeColors.default.textPrimary, for: .normal)
        }
    }
    
    @objc func easeBtnPressed(_ sender: UIButton) {
        moveBtnSelectionChange(isSelected: false)
        animateBtnSelectionChange(isSelected: false)
        easeBtnSelectionChange(isSelected: true)
        if cameraFeatureUsingMapplsPin {
            easeCameraTo(mapplsPin: "mmi000")
        }else {
            easeCameraTo(coordinate: .init(latitude: 28.551078, longitude: 77.268968))
        }
    }
    
    @objc func moveBtnPressed(_ sender: UIButton) {
        easeBtnSelectionChange(isSelected: false)
        animateBtnSelectionChange(isSelected: false)
        moveBtnSelectionChange(isSelected: true)
        if cameraFeatureUsingMapplsPin {
            moveCameraTo(mapplsPin: "mmi000")
        }else {
            moveCameraTo(coordinate: .init(latitude: 22.5744, longitude: 88.3629))
        }
    }
    
    @objc func animateBtnPressed(_ sender: UIButton) {
        easeBtnSelectionChange(isSelected: false)
        moveBtnSelectionChange(isSelected: false)
        animateBtnSelectionChange(isSelected: true)
        if cameraFeatureUsingMapplsPin {
            animateCameraTo(mapplsPin: "mmi000")
        }else {
            animateCameraTo(coordinate: .init(latitude: 13.0843, longitude: 80.2705))
        }
    }
    
    func easeCameraTo(mapplsPin: String) {
        let camera = MGLMapCamera.init(lookingAtCenterMapplsPin: mapplsPin, acrossDistance: 1000, pitch: 0.0, heading: 0)
        mapView.setCamera(camera, withDuration: 1.0, animationTimingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn))
    }
    
    func moveCameraTo(mapplsPin: String) {
        let camera = MGLMapCamera.init(lookingAtCenterMapplsPin: mapplsPin, acrossDistance: 1000, pitch: 0.0, heading: 0)
        mapView.setCamera(camera, animated: false)
    }
    
    func animateCameraTo(mapplsPin: String) {
        let camera = MGLMapCamera.init(lookingAtCenterMapplsPin: mapplsPin, acrossDistance: 1000, pitch: 0.0, heading: 0)
        mapView.fly(to: camera)
    }
    
    func easeCameraTo(coordinate: CLLocationCoordinate2D) {
        let camera = MGLMapCamera.init(lookingAtCenter: coordinate, altitude: 1000, pitch: 0.0, heading: 0)
        mapView.setCamera(camera, withDuration: 1.0, animationTimingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn))
    }
    
    func moveCameraTo(coordinate: CLLocationCoordinate2D) {
        let camera = MGLMapCamera(lookingAtCenter: coordinate, altitude: 1000, pitch: 0.0, heading: 0)
        mapView.setCamera(camera, animated: false)
    }
    
    func animateCameraTo(coordinate: CLLocationCoordinate2D) {
        let camera = MGLMapCamera(lookingAtCenter: coordinate, altitude: 1000, pitch: 0.0, heading: 0)
        mapView.fly(to: camera)
    }
    
    func setLocationCameraOptionView() {
        bottomBgView = UIView()
        bottomBgView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBgView!)
        
        portraitConstraints.append(bottomBgView!.heightAnchor.constraint(equalToConstant: 65 + bottomSafeAreaInset))
        landscapeHeightConstraints.append(bottomBgView!.heightAnchor.constraint(equalToConstant: 75))
        
        NSLayoutConstraint.activate([
            bottomBgView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBgView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBgView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.activate(portraitConstraints)
        }else {
            NSLayoutConstraint.activate(landscapeHeightConstraints)
        }
        
        mapCenterBtnBtmCons.isActive = false
        mapCenterBtnBtmCons = mapCenterBtn.bottomAnchor.constraint(equalTo: bottomBgView!.topAnchor, constant: -30)
        mapCenterBtnBtmCons.isActive = true
        
        let modeSelectionTitle = "\(currentSelectedMode.rawValue)         "
        
        modeSelectionBtn = UIButton(type: .system)
        modeSelectionBtn!.setTitle(String(modeSelectionTitle.prefix(14)), for: .normal)
        modeSelectionBtn?.setImage(UIImage(named: "right-arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        modeSelectionBtn?.layer.cornerCurve = .continuous
        modeSelectionBtn?.layer.cornerRadius = 20
        modeSelectionBtn?.addTarget(self, action: #selector(self.modeSelectionBtnClicked), for: .touchUpInside)
        modeSelectionBtn?.layer.borderWidth = 2
        modeSelectionBtn?.semanticContentAttribute = .forceRightToLeft
        modeSelectionBtn?.titleLabel?.textAlignment = .left
        modeSelectionBtn!.translatesAutoresizingMaskIntoConstraints = false
        bottomBgView!.addSubview(modeSelectionBtn!)
        
        NSLayoutConstraint.activate([
            modeSelectionBtn!.trailingAnchor.constraint(equalTo: bottomBgView!.centerXAnchor, constant: -10),
            modeSelectionBtn!.heightAnchor.constraint(equalToConstant: 40),
            modeSelectionBtn!.widthAnchor.constraint(equalToConstant: 110),
            modeSelectionBtn!.centerYAnchor.constraint(equalTo: bottomBgView!.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        modeLbl = UILabel()
        modeLbl!.font = UIFont(name: "Roboto-Regular", size: 15)
        modeLbl!.text = "Mode:"
        modeLbl!.translatesAutoresizingMaskIntoConstraints = false
        bottomBgView?.addSubview(modeLbl!)
        
        NSLayoutConstraint.activate([
            modeLbl!.trailingAnchor.constraint(equalTo: modeSelectionBtn!.leadingAnchor, constant: -10),
            modeLbl!.centerYAnchor.constraint(equalTo: bottomBgView!.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        trackingLbl = UILabel()
        trackingLbl?.font = UIFont(name: "Roboto-Regular", size: 15)
        trackingLbl?.text = "Tracking:"
        trackingLbl?.translatesAutoresizingMaskIntoConstraints = false
        bottomBgView?.addSubview(trackingLbl!)
        
        NSLayoutConstraint.activate([
            trackingLbl!.leadingAnchor.constraint(equalTo: bottomBgView!.centerXAnchor),
            trackingLbl!.centerYAnchor.constraint(equalTo: bottomBgView!.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        let trackingTypeTitle = "\(currentSelectedTrackingType.abbreviated)           "
        
        trackingSelectionButton = UIButton(type: .system)
        trackingSelectionButton!.setTitle(String(trackingTypeTitle.prefix(14)), for: .normal)
        trackingSelectionButton?.setImage(UIImage(named: "right-arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        trackingSelectionButton!.layer.cornerCurve = .continuous
        trackingSelectionButton!.layer.cornerRadius = 20
        trackingSelectionButton!.layer.borderWidth = 2
        trackingSelectionButton?.addTarget(self, action: #selector(self.trackingSelectionButtonClicked), for: .touchUpInside)
        trackingSelectionButton!.semanticContentAttribute = .forceRightToLeft
        trackingSelectionButton!.titleLabel?.textAlignment = .left
        trackingSelectionButton?.translatesAutoresizingMaskIntoConstraints = false
        bottomBgView?.addSubview(trackingSelectionButton!)
        
        NSLayoutConstraint.activate([
            trackingSelectionButton!.leadingAnchor.constraint(equalTo: trackingLbl!.trailingAnchor, constant: 5),
            trackingSelectionButton!.heightAnchor.constraint(equalToConstant: 40),
            trackingSelectionButton!.widthAnchor.constraint(equalToConstant: 110),
            trackingSelectionButton!.centerYAnchor.constraint(equalTo: trackingLbl!.centerYAnchor)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    @objc func trackingSelectionButtonClicked() {
        let vc = MapCameraTrackingTypeConfigurationSelectionViewController()
        vc.delegate = self
        vc.currentSelectedType = currentSelectedTrackingType
        sheet = Utility.openSheetViewController(from: self, in: self.view, controller: vc, size: [.percent(0.5), .percent(0.7)], dismissOnPullOrTap: true)
        sheet?.handleScrollView(vc.tableView)
    }
    
    @objc func modeSelectionBtnClicked() {
        let vc = MapCameraModeConfigurationSelectionViewController()
        vc.currentSelectedMode = currentSelectedMode
        vc.delegate = self
        sheet = Utility.openSheetViewController(from: self, in: self.view, controller: vc, size: [.percent(0.5), .percent(0.7)], dismissOnPullOrTap: true)
        sheet?.handleScrollView(vc.tableView)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.deactivate(landscapeHeightConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
        }else {
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeHeightConstraints)
        }
    }
}

extension CameraViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
            self.bottomBgView?.backgroundColor = theme.backgroundSecondary
            self.easeBtn?.setTitleColor(theme.textPrimary, for: .normal)
            self.easeBtn?.backgroundColor = theme.strokeBorder
            self.easeBtn?.layer.borderColor = theme.textSecondary.cgColor
            self.moveBtn?.setTitleColor(theme.textPrimary, for: .normal)
            self.moveBtn?.backgroundColor = theme.strokeBorder
            self.moveBtn?.layer.borderColor = theme.textSecondary.cgColor
            self.animateBtn?.setTitleColor(theme.textPrimary, for: .normal)
            self.animateBtn?.backgroundColor = theme.strokeBorder
            self.animateBtn?.layer.borderColor = theme.textSecondary.cgColor
            self.modeSelectionBtn?.backgroundColor = theme.strokeBorder
            self.modeSelectionBtn?.layer.borderColor = theme.textSecondary.cgColor
            self.modeSelectionBtn?.setTitleColor(theme.textPrimary, for: .normal)
            self.modeSelectionBtn?.tintColor = theme.textPrimary
            self.modeLbl?.textColor = theme.textPrimary
            self.trackingSelectionButton?.backgroundColor = theme.strokeBorder
            self.trackingSelectionButton?.layer.borderColor = theme.textSecondary.cgColor
            self.trackingSelectionButton?.setTitleColor(theme.textPrimary, for: .normal)
            self.trackingSelectionButton?.tintColor = theme.textPrimary
            self.trackingLbl?.textColor = theme.textPrimary
        }
    }
}

extension CameraViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        switch cameraSubOptionSelected {
        case .cameraFeature:
            setCameraFeaturesView()
        case .locationCameraOptions:
            setLocationCameraOptionView()
        case .cameraFeaturesInMapplsPin:
            setCameraFeaturesView()
            cameraFeatureUsingMapplsPin = true
        default:
            break
        }
    }
}

extension CameraViewController: NavigationProtocol, MapCameraTrackingTypeConfigurationSelectionViewControllerDelegate, MapCameraModeConfigurationSelectionViewControllerDelegate {
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func didDismiss() {
        sheet?.attemptDismiss(animated: true)
    }
    
    func didSelectCameraMode(mode: CameraMode) async {
        sheet?.attemptDismiss(animated: true)
        switch mode {
        case .normal:
            break
        case .gps:
            break
        case .compass:
            break
        }
        currentSelectedMode = mode
    }
    
    func didSelectCameraTracking(type: CameraTrackingType) {
        sheet?.attemptDismiss(animated: true)
        switch type {
        case .none:
            mapView.setUserTrackingMode(.none, animated: true, completionHandler: nil)
        case .noneCompass:
            break
        case .trackingGPSNorth:
            break
        case .trackingGPS:
            mapView.setUserTrackingMode(.followWithCourse, animated: true, completionHandler: nil)
        case .tracking:
            mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        case .trackingCompass:
            mapView.setUserTrackingMode(.followWithHeading, animated: true, completionHandler: nil)
        }
        currentSelectedTrackingType = type
    }
}
