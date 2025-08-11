//
//  MapplsGeofenceUIViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 23/01/25.
//

import UIKit
import MapplsGeofenceUI

class MapplsGeofenceUIViewController: UIViewController {
    
    var navBarView: NavigationBarView!
    var geofenceView: MapplsGeofenceView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        navBarView = NavigationBarView(title: SubOptionsEnum.geofenceUI.rawValue)
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
        
        geofenceView = MapplsGeofenceView()
        geofenceView.delegate = self
        geofenceView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(geofenceView)
        
        NSLayoutConstraint.activate([
            geofenceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            geofenceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            geofenceView.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            geofenceView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
}

extension MapplsGeofenceUIViewController: MapplsGeofenceViewDelegate {
    func geofenceModeChanged(mode: MapplsGeofenceUI.MapplsOverlayShapeGeometryType) {
        
    }
    
    func didPolygonReachedMaximumPoints() {
        
    }
    
    func hasIntersectPoints(_ shape: MapplsGeofenceUI.MapplsGeofenceShape) {
        
    }
    
    func circleRadiusChanged(radius: Double) {
        
    }
    
    func didDragGeofence(isdragged: Bool) {
        
    }
    
    func geofenceShapeDidChanged(_ shape: MapplsGeofenceShape) {
        
    }
}

extension MapplsGeofenceUIViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
        }
    }
}

extension MapplsGeofenceUIViewController: NavigationProtocol {
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}
