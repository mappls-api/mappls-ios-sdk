//
//  CustomWidgetsPlacePickerViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 16/01/25.
//

import UIKit
import MapplsMap
import MapplsUIWidgets

class CustomWidgetsPlacePickerViewController: UIViewController {
    
    var navBarView: NavigationBarView!
    var placePickerView: PlacePickerView!
    var isMarkerShadowViewHidden: Bool = false
    var customMarker: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        navBarView = NavigationBarView(title: SubOptionsEnum.placePickerView.rawValue)
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
        
        let mapView = MapplsMapView()
        placePickerView = PlacePickerView(frame: .zero, parentViewController: self, mapView: mapView)
        placePickerView.delegate = self
        placePickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placePickerView)
        
        if let customMarker = customMarker {
            placePickerView.markerView = customMarker
        }
        
        NSLayoutConstraint.activate([
            placePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placePickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placePickerView.topAnchor.constraint(equalTo: navBarView.bottomAnchor)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
}

extension CustomWidgetsPlacePickerViewController: NavigationProtocol {
    func navigateBack() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }else {
            dismiss(animated: true)
        }
    }
}

extension CustomWidgetsPlacePickerViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
        }
    }
}

extension CustomWidgetsPlacePickerViewController: PlacePickerViewDelegate {
    func didCancelPlacePicker() {
        
    }
    
    func didPickedLocation(placemark: MapplsGeocodedPlacemark) {
        
    }
    
    func didReverseGeocode(placemark: MapplsGeocodedPlacemark) {
        
    }
    
    func didFailedReverseGeocode(error: NSError?) {
        
    }
}
