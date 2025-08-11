//
//  OptionDetailViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 08/01/25.
//

import UIKit
import MapplsMap
import MapplsAPIKit

class OptionDetailViewController: UIViewController {
    
    var navBarView: NavigationBarView!
    var mapView: MapplsMapView!
    var option: SubOptionsEnum!
    var mapCenterBtn: UIButton!
    var latLongDisplatToast: LatLongDisplayToast = LatLongDisplayToast()
    var placeDetailView: PlaceAddressDetailView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        navBarView = NavigationBarView(title: option.rawValue)
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
        mapView.showsUserLocation = true
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
        
        NSLayoutConstraint.activate([
            mapCenterBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mapCenterBtn.heightAnchor.constraint(equalToConstant: 50),
            mapCenterBtn.widthAnchor.constraint(equalToConstant: 50),
            mapCenterBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    @objc func centerMap() {
        if let location = mapView.userLocation {
            mapView.setCenter(location.coordinate, zoomLevel: 18, animated: true)
        }
    }
    
    func addMapGesture() {
        addLatLongDisplayViewToMap(isHidden: false)
    }
    
    func addLongTapGesture() {
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.mapLongTapGesture(_:)))
        mapView.addGestureRecognizer(longTapGesture)
        addLatLongDisplayViewToMap()
    }
    
    @objc func mapLongTapGesture(_ sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.location(in: mapView)
        let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        latLongDisplatToast.setLatLong(lat: coordinates.latitude, long: coordinates.longitude, altitude: mapView.camera.altitude, isOnMove: false)
        latLongDisplatToast.appear()
    }
    
    func addLatLongDisplayViewToMap(isHidden: Bool = true) {
        latLongDisplatToast = LatLongDisplayToast()
        latLongDisplatToast.setLatLong(lat: 0.0, long: 0.0, altitude: 0.0, isOnMove: false)
        latLongDisplatToast.isHidden = isHidden
        latLongDisplatToast.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(latLongDisplatToast)
        
        NSLayoutConstraint.activate([
            latLongDisplatToast.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            latLongDisplatToast.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            latLongDisplatToast.heightAnchor.constraint(equalToConstant: 60),
            latLongDisplatToast.bottomAnchor.constraint(equalTo: mapCenterBtn.topAnchor, constant: -20)
        ])
    }
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.mapTapGesture(_:)))
        mapView.addGestureRecognizer(tapGesture)
        addLatLongDisplayViewToMap()
    }
    
    @objc func mapTapGesture(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: mapView)
        let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        latLongDisplatToast.setLatLong(lat: coordinates.latitude, long: coordinates.longitude, altitude: mapView.camera.altitude, isOnMove: false)
        latLongDisplatToast.appear()
    }
    
    func addTraffic() {
        let trafficSelectionView = TrafficSelectionView()
        trafficSelectionView.delegate = self
        trafficSelectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trafficSelectionView)
        
        NSLayoutConstraint.activate([
            trafficSelectionView.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            trafficSelectionView.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 20),
            trafficSelectionView.heightAnchor.constraint(equalToConstant: 190),
            trafficSelectionView.widthAnchor.constraint(equalToConstant: 170)
        ])
    }
    
    func addPlaceTapView() {
        placeDetailView = PlaceAddressDetailView()
        placeDetailView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeDetailView!)
        
        NSLayoutConstraint.activate([
            placeDetailView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            placeDetailView!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            placeDetailView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placeDetailView!.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}

extension OptionDetailViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
        }
    }
}

extension OptionDetailViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        if let location = mapView.userLocation {
            mapView.setCamera(MGLMapCamera.init(lookingAtCenter: location.coordinate, altitude: 1000, pitch: 0, heading: 0), animated: true)
        }
        
        switch option {
        case .mapTraffic:
            addTraffic()
        case .mapTap:
            addTapGesture()
        case .mapLongTap:
            addLongTapGesture()
        case .mapGesture:
            addMapGesture()
        case .placeTap:
            addPlaceTapView()
        default:
            break
        }
    }
    
    func mapView(_ mapView: MGLMapView, didTapPlaceWithMapplsPin mapplsPin: String?) {
        if option == .placeTap, let mapplsPin = mapplsPin {
            let placeDetailManager = MapplsPlaceDetailManager.shared
            let placeOptions = MapplsPlaceDetailOptions(mapplsPin: mapplsPin, withRegion: .india)
            placeDetailManager.getResults(placeOptions) { (placeDetail, error) in
                self.placeDetailView?.setData(placeName: placeDetail?.placeName ?? "", placeAddress: placeDetail?.address ?? "")
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        if option == .mapGesture {
            latLongDisplatToast.setLatLong(lat: mapView.centerCoordinate.latitude, long: mapView.centerCoordinate.longitude, altitude: mapView.camera.altitude, isOnMove: true)
            latLongDisplatToast.appear()
        }
    }
}

extension OptionDetailViewController: NavigationProtocol {
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension OptionDetailViewController: TrafficSelectionProtocol {
    func showTraffic(enabled: Bool) {
        mapView.isTrafficEnabled = enabled
    }
    
    func showFreeFlow(enabled: Bool) {
        mapView.isFreeFlowTrafficEnabled = true
    }
    
    func showNonFreeFlow(enabled: Bool) {
        mapView.isNonFreeFlowTrafficEnabled = true
    }
    
    func showClosure(enabled: Bool) {
        mapView.isClosureTrafficEnabled = enabled
    }
    
    func showStopIcon(enabled: Bool) async {
        mapView.isStopIconTrafficEnabled = true
    }
}
