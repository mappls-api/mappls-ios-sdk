//
//  LocationViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 10/01/25.
//

import UIKit
import MapplsMap

class LocationViewController: UIViewController {
    
    var locationSubOptionSelected: SubOptionsEnum!
    var navBarView: NavigationBarView!
    var mapView: MapplsMapView!
    var mapCenterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        navBarView = NavigationBarView(title: locationSubOptionSelected.rawValue)
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
        if let location = mapView.userLocation?.location ?? CLLocationManager().location {
            mapView.setCenter(location.coordinate, zoomLevel: 18, animated: true)
        }
    }
}

extension LocationViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        switch locationSubOptionSelected {
        case .showUserLocation:
            mapView.showsUserLocation = true
        case .showUserHeading:
            mapView.setUserTrackingMode(.followWithCourse, animated: true, completionHandler: nil)
        case .showUserCourseTracking:
            mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        case .customUserLocationIcon:
            mapView.showsUserLocation = true
        default:
            break
        }
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        if locationSubOptionSelected == .customUserLocationIcon, let _ = annotation as? MGLUserLocation {
            let userAnnotationView = CustomUserLocationAnnotationView(reuseIdentifier: locationSubOptionSelected.rawValue)
            return userAnnotationView
        }
        return nil
    }
}

extension LocationViewController: NavigationProtocol {
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension LocationViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
        }
    }
}
