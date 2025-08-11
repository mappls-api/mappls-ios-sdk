//
//  UtilityViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 01/02/25.
//

import UIKit
import MapplsMap
import MapplsAPIKit

class UtilityViewController: UIViewController {
    var utilitySubOptionSelected: SubOptionsEnum!
    var navBarView: NavigationBarView!
    var mapView: MapplsMapView!
    var mapCenterBtn: UIButton!
    var digiPinEntryView: DIGIPINTopEntryView?
    var mapCenterBtnBtmCons: NSLayoutConstraint = .init()
    var bottomLblView: BottomLabelsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        navBarView = NavigationBarView(title: utilitySubOptionSelected.rawValue)
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
        
        mapView = MapplsMapView()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
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
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.mapViewDidTap))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func mapViewDidTap(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        addAnnotation(with: coordinate)
        let digiPin = MapplsDigiPinUtility().getDigiPin(from: coordinate)
        digiPinEntryView?.digiPinField.text = digiPin
        digiPinEntryView?.coordinateField.text = "\(coordinate.latitude),\(coordinate.longitude)"
    }
    
    @objc func addAnnotation(with coordinate: CLLocationCoordinate2D) {
        let annotation: MGLPointAnnotation = .init()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        mapView.setCenter(coordinate, zoomLevel: 12, animated: true)
    }
    
    @objc func centerMap() {
        if let location = mapView.userLocation?.location ?? CLLocationManager().location {
            mapView.setCenter(location.coordinate, zoomLevel: 18, animated: true)
        }
    }
    
    func addDIGIPINViews() {
        digiPinEntryView = DIGIPINTopEntryView()
        digiPinEntryView!.delegate = self
        digiPinEntryView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(digiPinEntryView!)
        
        NSLayoutConstraint.activate([
            digiPinEntryView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            digiPinEntryView!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            digiPinEntryView!.topAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: 10),
            digiPinEntryView!.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        bottomLblView = BottomLabelsView()
        bottomLblView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomLblView!)
        
        NSLayoutConstraint.activate([
            bottomLblView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomLblView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomLblView!.heightAnchor.constraint(equalToConstant: 80),
            bottomLblView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        mapCenterBtnBtmCons.isActive = false
        mapCenterBtnBtmCons = mapCenterBtn.bottomAnchor.constraint(equalTo: bottomLblView!.topAnchor, constant: -30)
        mapCenterBtnBtmCons.isActive = true
        
        view.bringSubviewToFront(mapCenterBtn)
    }
}

extension UtilityViewController: DIGIPINTopEntryViewDelegate {
    func setCoordinateBtnPressed(with digiPin: String) async {
        if let location = MapplsDigiPinUtility().getCoordinate(from: digiPin) {
            self.bottomLblView?.bottomLbl.text = "Coordinate - \(location.coordinate.latitude),\(location.coordinate.longitude)"
        }else {
            let alertController = UIAlertController(title: "No DIGIPIN", message: "Please click anywhere on map to enter DIGIPIN or add manually", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
    
    func setDigipinBtnPressed(with coordinate: String) async {
        let split = coordinate.split(separator: ",")
        guard split.indices.contains(0), split.indices.contains(1) else {
            let alertController = UIAlertController(title: "No coordinate", message: "Please click anywhere on map to enter coordinate or add manually", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            return
        }
        if let lat = Double(String(split[0])), let long = Double(String(split[1])) {
            let digipin = MapplsDigiPinUtility().getDigiPin(from: .init(latitude: lat, longitude: long))
            bottomLblView?.topLbl.text = "DigiPin - \(digipin)"
            addAnnotation(with: .init(latitude: lat, longitude: long))
        }
    }
}

extension UtilityViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        switch utilitySubOptionSelected {
        case .digiPin:
            addTapGesture()
            addDIGIPINViews()
        default:
            break
        }
    }
}

extension UtilityViewController: NavigationProtocol {
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension UtilityViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
        }
    }
}

