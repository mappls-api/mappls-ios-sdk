//
//  RestAPITripPlanViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 03/02/25.
//

import UIKit
import MapplsAPIKit
import MapplsMap
import MapplsUIWidgets

class EVAnnotation: MGLPointAnnotation {
    var image: UIImage = UIImage(named: "category_nearby_ic_map_evcharging_utilitiesDay")!
}

class RestAPITripPlanViewController: UIViewController {
    
    var navBarView: NavigationBarView!
    var mapView: MapplsMapView!
    var mapCenterBtn: UIButton!
    var clearBtn: UIButton!
    var searchButton: UIButton!
    var getEVTripPlanButton: UIButton!
    var currentRoute: Route?
    var evChargeStationsAnnotation: [EVAnnotation] = []
    var smartTripWaypoints: [Waypoint] = []
    var waypoints: [Waypoint] = [] {
        didSet {
            callRouteApiWithSourceDestinationCoordinate()
        }
    }
    var annotations: [MGLPointAnnotation] = [] {
        didSet {
            if let last = annotations.last {
                mapView.addAnnotation(last)
                mapView.showAnnotations(annotations, animated: true)
            }
        }
    }
    var searchResults: [MapplsAtlasSuggestion] = [] {
        didSet {
            if let last = searchResults.last {
                let annotation = MGLPointAnnotation()
                annotation.coordinate = .init(latitude: Double(last.latitude ?? 0.0), longitude: Double(last.longitude ?? 0.0))
                annotations.append(annotation)
                waypoints.append(.init(coordinate: annotation.coordinate))
            }
        }
    }
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        navBarView = NavigationBarView(title: SubOptionsEnum.tripPlanAPI.rawValue)
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
        
        clearBtn = UIButton(type: .system)
        clearBtn.layer.cornerRadius = 25
        clearBtn.addShadow(radius: 3, opacity: 0.5, offset: .init(width: 0, height: 4))
        clearBtn.setImage(UIImage(systemName: "xmark")!.withRenderingMode(.alwaysTemplate), for: .normal)
        clearBtn.addTarget(self, action: #selector(self.clearBtnClicked), for: .touchUpInside)
        clearBtn.isHidden = true
        clearBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clearBtn)
        
        NSLayoutConstraint.activate([
            clearBtn.heightAnchor.constraint(equalToConstant: 50),
            clearBtn.widthAnchor.constraint(equalToConstant: 50),
            clearBtn.trailingAnchor.constraint(equalTo: mapCenterBtn.trailingAnchor),
            clearBtn.bottomAnchor.constraint(equalTo: mapCenterBtn.topAnchor, constant: -20)
        ])
        
        getEVTripPlanButton = UIButton(type: .system)
        getEVTripPlanButton.setTitle("Get EV Trip Plan", for: .normal)
        getEVTripPlanButton.addTarget(self, action: #selector(self.getEVTripPlanButtonPressed), for: .touchUpInside)
        getEVTripPlanButton.layer.borderWidth = 1
        getEVTripPlanButton.layer.cornerRadius = 12
        getEVTripPlanButton.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(getEVTripPlanButton)
        
        NSLayoutConstraint.activate([
            getEVTripPlanButton.trailingAnchor.constraint(equalTo: navBarView.trailingAnchor, constant: -20),
            getEVTripPlanButton.heightAnchor.constraint(equalToConstant: 40),
            getEVTripPlanButton.widthAnchor.constraint(equalToConstant: 120),
            getEVTripPlanButton.centerYAnchor.constraint(equalTo: navBarView.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        searchButton = UIButton(type: .system)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.layer.cornerRadius = 25
        searchButton.addTarget(self, action: #selector(self.didTapOnSearchButton), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            searchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.widthAnchor.constraint(equalToConstant: 50),
            searchButton.topAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: 20)
        ])
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    @objc func getEVTripPlanButtonPressed() {
        guard waypoints.count > 1, let route = currentRoute else {return}
        let options = MapplsSmartTripPlanOptions(geom: route.geometry ?? "", actualDistanceToEmpty: 60, stateOfCharge: 80, searchSoc: 120, snappedWaypoints: waypoints, waypoint: route.routeOptions.waypoints)
        let manager = MapplsSmartTripPlanManager()
        activityIndicator.startAnimating()
        manager.getSmartTripResult(options) { response, error in
            if let error = error {
                print(error.localizedDescription)
                self.activityIndicator.stopAnimating()
            }else if let response = response {
                response.results?.forEach({ stop in
                    self.smartTripWaypoints.append(.init(coordinate: .init(latitude: stop.latitude ?? 0.0, longitude: stop.longitude ?? 0.0)))
                    let annoatation = EVAnnotation()
                    annoatation.coordinate = .init(latitude: stop.latitude ?? 0.0, longitude: stop.longitude ?? 0.0)
                    self.mapView.addAnnotation(annoatation)
                    self.evChargeStationsAnnotation.append(annoatation)
                })
                self.callRouteApiWithSmartTripWaypoints()
            }
        }
    }
    
    @objc func clearBtnClicked() {
        mapView.removeAnnotations(mapView.annotations ?? [])
        waypoints = []
        annotations = []
        searchResults = []
        evChargeStationsAnnotation = []
    }
    
    func callRouteApiWithSmartTripWaypoints() {
        guard smartTripWaypoints.count > 1 else {return}
        activityIndicator.startAnimating()
        
        let options = RouteOptions(waypoints: smartTripWaypoints, resourceIdentifier: .routeAdv, profileIdentifier: .driving)
        options.includesSteps = true
        let _ = Directions.shared.calculate(options) { (waypoints, routes, error) in
            self.activityIndicator.stopAnimating()
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }
            if let route = routes?.first {
                self.currentRoute = route
                self.removeAndPlotPolylineAndAnnotations(for: route)
            }
        }
    }
    
    func callRouteApiWithSourceDestinationCoordinate() {
        guard waypoints.count > 1 else {return}
        
        activityIndicator.startAnimating()
        
        let options = RouteOptions(waypoints: waypoints, resourceIdentifier: .routeAdv, profileIdentifier: .driving)
        options.includesSteps = true
        let _ = Directions.shared.calculate(options) { (waypoints, routes, error) in
            self.activityIndicator.stopAnimating()
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }
            if let route = routes?.first {
                self.currentRoute = route
                self.removeAndPlotPolylineAndAnnotations(for: route)
            }
        }
    }
    
    func isWpInEvAnnotation(coordinate: CLLocationCoordinate2D) -> Bool {
        for annotation in evChargeStationsAnnotation {
            if annotation.coordinate == coordinate {return true}
        }
        return false
    }
    
    func removeAndPlotPolylineAndAnnotations(for route: Route) {
        mapView.removeAnnotations(annotations)
        route.routeOptions.waypoints.forEach { wp in
            guard !isWpInEvAnnotation(coordinate: wp.coordinate) else {return}
            let annotation = MGLPointAnnotation()
            annotation.coordinate = .init(latitude: wp.coordinate.latitude, longitude: wp.coordinate.longitude)
            annotations.append(annotation)
        }
        let polyline = MGLPolyline(coordinates: route.coordinates ?? [], count: route.coordinateCount)
        self.mapView.addAnnotation(polyline)
        self.mapView.showAnnotations([polyline], animated: true)
    }
    
    @objc func didTapOnSearchButton() {
        let vc = MapplsAutocompleteViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc func centerMap() {
        if let location = CLLocationManager().location {
            mapView.setCenter(location.coordinate, zoomLevel: 18, animated: true)
        }
    }
}

extension RestAPITripPlanViewController: MapplsAutocompleteViewControllerDelegate {
    func didAutocomplete(viewController: MapplsUIWidgets.MapplsAutocompleteViewController, withPlace place: MapplsAPIKit.MapplsAtlasSuggestion, resultType type: MapplsAutosuggestResultType) {
        viewController.dismiss(animated: true)
        searchResults.append(place)
    }
    
    func didAutocomplete(viewController: MapplsUIWidgets.MapplsAutocompleteViewController, withFavouritePlace place: MapplsUIWidgets.MapplsUIWidgetAutosuggestFavouritePlace) {
        
    }
    
    func didFailAutocomplete(viewController: MapplsUIWidgets.MapplsAutocompleteViewController, withError error: NSError) {
        
    }
    
    func wasCancelled(viewController: MapplsUIWidgets.MapplsAutocompleteViewController) {
        
    }
    
    func didAutocomplete(viewController: MapplsAutocompleteViewController, withSuggestion suggestion: MapplsSearchPrediction) {
        
    }
}

extension RestAPITripPlanViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if let annotation = annotation as? EVAnnotation {
            let image = MGLAnnotationImage(image: annotation.image, reuseIdentifier: "evAnnotation")
            return image
        }
        return nil
    }
}

extension RestAPITripPlanViewController: NavigationProtocol {
    func navigateBack() async {
        navigationController?.popViewController(animated: true)
    }
}

extension RestAPITripPlanViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
            self.searchButton.backgroundColor = theme.backgroundSecondary
            self.searchButton.tintColor = theme.textPrimary
            self.clearBtn.tintColor = theme.textPrimary
            self.clearBtn.backgroundColor = theme.backgroundPrimary
            self.getEVTripPlanButton.layer.borderColor = theme.strokeBorder.cgColor
            self.getEVTripPlanButton.backgroundColor = theme.backgroundSecondary
            self.getEVTripPlanButton.setTitleColor(theme.textPrimary, for: .normal)
        }
    }
}
