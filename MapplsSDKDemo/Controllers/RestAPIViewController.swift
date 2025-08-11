//
//  RestAPIViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 10/01/25.
//

import UIKit
import MapplsMap
import FittedSheets

class RestAPIViewController: UIViewController {
    
    var restAPISubOptionSelected: SubOptionsEnum!
    var navBarView: NavigationBarView!
    var mapView: MapplsMapView!
    var mapCenterBtn: UIButton!
    var addressDetailView: PlaceAddressDetailView?
    var mapCenterBtnBottomConstraint: NSLayoutConstraint!
    var infoTableView: UITableView?
    var infoTableViewDataSource: UITableViewDiffableDataSource<Int, KeyValueHashable>?
    var infoTableViewPortraitConstraints: NSLayoutConstraint?
    var infoTableViewLandscapeConstraints: NSLayoutConstraint?
    var infoTableViewData: [KeyValueHashable] = []
    var navBarTextfieldButton: UIButton?
    var sheet: SheetViewController?
    var currentRouteOnMap: Route?
    var sourceRoutingCoordinateSelected: CLLocationCoordinate2D?
    var destinationRoutingCoordinateSelected: CLLocationCoordinate2D?
    let activityIndicator = UIActivityIndicatorView()
    var lastAlertTextFieldValue: String = "" {
        didSet {
            switch self.restAPISubOptionSelected {
            case .nearbyAPI:
                let refLocations: String = "\(mapView.userLocation?.coordinate.latitude ?? CLLocationManager().location?.coordinate.latitude ?? 0.0), \(mapView.userLocation?.coordinate.longitude ?? CLLocationManager().location?.coordinate.longitude ?? 0.0)"
//                let refLocations: String = "28.543014, 77.242342"

                let sortBy = MapplsSortByDistanceWithOrder(orderBy: .ascending)
                
                let nearByOptions = MapplsNearbyAtlasOptions(query: lastAlertTextFieldValue, location: refLocations, withRegion: .india)
                nearByOptions.sortBy = sortBy
                nearByOptions.searchBy = .importance
                
                APIManager.getNearBySuggestions(options: nearByOptions) { suggestions in
                    guard let suggestions = suggestions else {return}
                    if suggestions.count > 0 {
                        var annotations: [MGLPointAnnotation] = []
                        suggestions.forEach { suggestion in
                            let annotation = MGLPointAnnotation()
                            annotation.coordinate = .init(latitude: Double(truncating: suggestion.latitude ?? 0.0), longitude: Double(truncating: suggestion.longitude ?? 0.0))
                            annotations.append(annotation)
                        }
                        self.mapView.removeAnnotations(self.mapView.annotations ?? [])
                        self.mapView.addAnnotations(annotations)
                        self.mapView.showAnnotations(annotations, animated: true)
                    }
                } failure: { error in
                    if error.code == 204 {
                        let alertController = UIAlertController(title: "No Suggestion Found", message: "", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default)
                        alertController.addAction(action)
                        self.navigationController?.present(alertController, animated: true)
                    }else {
                        print(error.localizedDescription)
                    }
                }
            case .geocodeAPI:
                let atlasGeocodeOptions = MapplsAtlasGeocodeOptions(query: self.lastAlertTextFieldValue, withRegion: .india)
                activityIndicator.startAnimating()
                APIManager.getGeocodeResults(option: atlasGeocodeOptions) { placemarks in
                    if let placemarks = placemarks {
                        let annotation = MGLPointAnnotation()
                        annotation.coordinate = .init(latitude: Double(truncating: placemarks.first?.latitude ?? 0.0), longitude: Double(truncating: placemarks.first?.longitude ?? 0.0))
                        self.mapView.addAnnotation(annotation)
                        self.mapView.setCenter(.init(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude), zoomLevel: 18, animated: true)
                        self.activityIndicator.stopAnimating()
                    }
                } failure: { error in
                    print(error.localizedDescription)
                    self.activityIndicator.stopAnimating()
                }
            case .poiAlongRouteAPI:
                guard let route = self.currentRouteOnMap else {return}
                let routePath = route.geometry
                let poiAlongTheRouteOptions = MapplsPOIAlongTheRouteOptions(path: routePath ?? "", category: self.lastAlertTextFieldValue)
                poiAlongTheRouteOptions.buffer = 300
                APIManager.poiAlongRoute(option: poiAlongTheRouteOptions) { suggestions in
                    if let suggestions = suggestions {
                        var annotations: [MGLPointAnnotation] = []
                        suggestions.forEach { suggestion in
                            let annotation = MGLPointAnnotation()
                            annotation.coordinate = .init(latitude: Double(truncating: (suggestion.latitude ?? 0.0) as NSNumber), longitude: Double(truncating: (suggestion.longitude ?? 0.0) as NSNumber))
                            self.mapView.addAnnotation(annotation)
                            annotations.append(annotation)
                        }
                        self.mapView.showAnnotations(annotations, animated: true)
                    }
                } failure: { error in
                    if error.code == 204 {
                        let alertController = UIAlertController(title: "No Suggestion Found", message: "", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default)
                        alertController.addAction(action)
                        self.navigationController?.present(alertController, animated: true)
                    }else {
                        print(error.localizedDescription)
                    }
                }
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        navBarView = NavigationBarView(title: restAPISubOptionSelected.rawValue)
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
        mapView.showsUserLocation = true
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
        
        mapCenterBtnBottomConstraint = mapCenterBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        
        NSLayoutConstraint.activate([
            mapCenterBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mapCenterBtn.heightAnchor.constraint(equalToConstant: 50),
            mapCenterBtn.widthAnchor.constraint(equalToConstant: 50),
            mapCenterBtnBottomConstraint
        ])
        
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .Colors.pureWhite
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(activityIndicator, aboveSubview: mapView)
        
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: mapView.centerXAnchor)
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
    
    func setInfoTableView(for data: [KeyValueHashable]) {
        infoTableView = UITableView()
        infoTableView?.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.identifer)
        infoTableView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoTableView!)
        
        infoTableViewPortraitConstraints = infoTableView?.topAnchor.constraint(equalTo: view.centerYAnchor)
        infoTableViewLandscapeConstraints = infoTableView?.topAnchor.constraint(equalTo: navBarView.bottomAnchor)
        
        NSLayoutConstraint.activate([
            infoTableView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            infoTableView!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            infoTableView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if traitCollection.verticalSizeClass == .regular {
            infoTableViewPortraitConstraints?.isActive = true
        }else {
            infoTableViewLandscapeConstraints?.isActive = true
        }
        
        infoTableViewDataSource = UITableViewDiffableDataSource<Int, KeyValueHashable>(tableView: infoTableView!) { tableView, indexPath, itemIdentifier in
            guard data.indices.contains(indexPath.row), let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifer) as?  InfoTableViewCell else {return UITableViewCell()}
            let dataItem = data[indexPath.row]
            cell.setData(data: dataItem)
            cell.selectionStyle = .none
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, KeyValueHashable>()
        snapshot.appendSections([0])
        snapshot.appendItems(data, toSection: 0)
        
        infoTableViewDataSource?.apply(snapshot)
        
        self.infoTableViewData = data
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if let _ = infoTableView {
            if traitCollection.verticalSizeClass == .regular {
                infoTableViewLandscapeConstraints?.isActive = false
                infoTableViewPortraitConstraints?.isActive = true
            }else {
                infoTableViewPortraitConstraints?.isActive = false
                infoTableViewLandscapeConstraints?.isActive = true
            }
        }
    }
    
    func setPlaceSheet(with data: [KeyValueHashable]) {
        let vc = KeyValueTableViewController()
        vc.data = data
        
        var sheetOptions = SheetOptions()
        sheetOptions.pullBarHeight = 10
        sheetOptions.useInlineMode = true
        sheetOptions.transitionAnimationOptions = .curveLinear
        
        let sheet = SheetViewController(controller: vc, sizes: [.percent(0.1), .percent(0.5), .percent(0.9)], options: sheetOptions)
        sheet.overlayColor = .clear
        sheet.dismissOnPull = false
        sheet.dismissOnOverlayTap = false
        sheet.allowGestureThroughOverlay = true
        sheet.allowPullingPastMaxHeight = false
        sheet.allowPullingPastMinHeight = false
        
        self.sheet?.attemptDismiss(animated: true)
        sheet.animateIn(to: view, in: self)
        sheet.handleScrollView(vc.tableView)
        self.sheet = sheet
        
        self.mapCenterBtnBottomConstraint.isActive = false
        self.mapCenterBtnBottomConstraint = self.mapCenterBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        self.mapCenterBtnBottomConstraint.isActive = true
    }
    
    func setPlaceAddressView(placeName: String, address: String) {
        if addressDetailView == nil {
            self.addressDetailView = PlaceAddressDetailView()
            self.addressDetailView!.setData(placeName: placeName, placeAddress: address)
            self.addressDetailView?.translatesAutoresizingMaskIntoConstraints = false
            mapView.addSubview(self.addressDetailView!)
            
            NSLayoutConstraint.activate([
                self.addressDetailView!.heightAnchor.constraint(equalToConstant: 90),
                self.addressDetailView!.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                self.addressDetailView!.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                self.addressDetailView!.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
            self.mapCenterBtnBottomConstraint.isActive = false
            self.mapCenterBtnBottomConstraint = self.mapCenterBtn.bottomAnchor.constraint(equalTo: self.addressDetailView!.topAnchor, constant: -30)
            self.mapCenterBtnBottomConstraint.isActive = true
        }else {
            self.addressDetailView!.setData(placeName: placeName, placeAddress: address)
        }
    }
    
    func setTextfieldBtn(with title: String) {
        navBarTextfieldButton = UIButton()
        navBarTextfieldButton!.setTitle(title, for: .normal)
        navBarTextfieldButton!.titleLabel?.numberOfLines = 0
        navBarTextfieldButton!.addTarget(self, action: #selector(self.openAlertWithTextField), for: .touchUpInside)
        navBarTextfieldButton!.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(navBarTextfieldButton!)
        
        NSLayoutConstraint.activate([
            navBarTextfieldButton!.heightAnchor.constraint(equalToConstant: 40),
            navBarTextfieldButton!.trailingAnchor.constraint(equalTo: navBarView.trailingAnchor, constant: -15),
            navBarTextfieldButton!.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            navBarTextfieldButton!.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        self.appThemeChanged(theme: .default)
    }
    
    @objc func openAlertWithTextField(_ sender: UIButton) {
        let alertController = UIAlertController(title: sender.titleLabel?.text ?? "", message: "", preferredStyle: .alert)
        alertController.addTextField()
        let action = UIAlertAction(title: "OK", style: .default) { action in
            self.lastAlertTextFieldValue = (alertController.textFields?[0] as? UITextField)?.text ?? ""
        }
        alertController.addAction(action)
        navigationController?.present(alertController, animated: true)
    }
    
    func setLongTapInfoLbl() {
        let infoLbl = UILabel()
        infoLbl.numberOfLines = 0
        infoLbl.font = UIFont(name: "Roboto-Regular", size: 14)
        infoLbl.text = "Long tap of map to select the source and destination coordinates"
        infoLbl.backgroundColor = .yellow
        infoLbl.textColor = .black
        infoLbl.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(infoLbl, aboveSubview: mapView)
        
        NSLayoutConstraint.activate([
            infoLbl.leadingAnchor.constraint(equalTo: navBarView.safeAreaLayoutGuide.leadingAnchor),
            infoLbl.trailingAnchor.constraint(equalTo: navBarView.safeAreaLayoutGuide.trailingAnchor),
            infoLbl.topAnchor.constraint(equalTo: navBarView.bottomAnchor)
        ])
    }
    
    func addGetWeatherInfoTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.showWeatherCondition))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func showWeatherCondition(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            let point: CGPoint = sender.location(in: view)
            let coordinate: CLLocationCoordinate2D = mapView.convert(point, toCoordinateFrom: view)
            
            mapView.removeAnnotations(mapView.annotations ?? [])
            
            let annotation = MGLPointAnnotation()
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)
            
            let options = MapplsWeatherRequestOptions(location: .init(coordinate: coordinate))
            options.unitType = .day
            options.unit = "5"
            options.theme = .light
            
            activityIndicator.startAnimating()
            
            APIManager.currentWeatherConditionAPI(option: options) { response in
                if let response = response, let weatherData = response.data {
                    
                    var keyValData: [KeyValueHashable] = []
                    let encoder = JSONEncoder()
                    let data = try? encoder.encode(weatherData)
                    guard let data = data else {return}
                    let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
                    guard let dictionary = json as? [String : AnyObject] else {
                        return
                    }
                    let _ = dictionary.keys.map({ key in
                        if let value = dictionary[key] {
                            if let valueDict = value as? NSDictionary {
                                let _ = valueDict.map { (key: Any, value: Any) in
                                    if let key = key as? String, !key.contains("Icon"), !key.contains("URL"), let value = valueDict[key] {
                                        if let numValue = value as? Double {
                                            keyValData.append(.init(key: key, value: String(numValue)))
                                        }else if let stringValue = value as? String {
                                            keyValData.append(.init(key: key, value: stringValue))
                                        }else {
                                            keyValData.append(.init(key: key, value: ""))
                                        }
                                    }
                                }
                            }
                        }
                    })
                    self.setPlaceSheet(with: keyValData)
                }
                self.activityIndicator.stopAnimating()
            } failure: { error in
                print(error.localizedDescription)
                self.activityIndicator.stopAnimating()
            }
        default:
            break
        }
    }
    
    func addRouteClearBtn() {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(ThemeColors.default.textPrimary, for: .normal)
        button.addTarget(self, action: #selector(self.clearMapAnnotations), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalToConstant: 60),
            button.trailingAnchor.constraint(equalTo: navBarView.trailingAnchor, constant: -15)
        ])
    }
    
    @objc func clearMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations ?? [])
        sourceRoutingCoordinateSelected = nil
        destinationRoutingCoordinateSelected = nil
    }
    
    func addLongTapGestureToMap() {
        let ltGesture = UILongPressGestureRecognizer()
        ltGesture.addTarget(self, action: #selector(self.longTappedOnMap))
        mapView.addGestureRecognizer(ltGesture)
    }
    
    @objc func longTappedOnMap(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .ended:
            if let _ = destinationRoutingCoordinateSelected {
                return
            }
            
            let point: CGPoint = sender.location(in: view)
            let coordinate: CLLocationCoordinate2D = mapView.convert(point, toCoordinateFrom: view)
            
            if let _ = sourceRoutingCoordinateSelected {
                let annotation: MGLPointAnnotation = MGLPointAnnotation()
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
                destinationRoutingCoordinateSelected = coordinate
                callRouteApiWithSourceDestinationCoordinate()
            }else {
                let annotation: MGLPointAnnotation = MGLPointAnnotation()
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
                sourceRoutingCoordinateSelected = coordinate
            }
        default:
            break
        }
    }
    
    func callRouteApiWithSourceDestinationCoordinate() {
        activityIndicator.startAnimating()
        
        guard let sourceRoutingCoordinateSelected = sourceRoutingCoordinateSelected, let destinationRoutingCoordinateSelected = destinationRoutingCoordinateSelected else {return}
        let options = RouteOptions(waypoints: [.init(coordinate: sourceRoutingCoordinateSelected), .init(coordinate: destinationRoutingCoordinateSelected)], resourceIdentifier: .routeAdv, profileIdentifier: .driving)
        options.includesSteps = true
        APIManager.getRoute(options: options) { routes, waypoints in
            if let routes = routes, let route = routes.first {
                let polyline = MGLPolylineFeature(coordinates: route.coordinates ?? [], count: route.coordinateCount)
                self.mapView.addAnnotation(polyline)
                self.mapView.showAnnotations([polyline], animated: true)
                self.currentRouteOnMap = route
            }
            self.activityIndicator.stopAnimating()
        } failure: { error in
            print(error.localizedDescription)
            self.activityIndicator.stopAnimating()
        }
    }
    
    func addGetNearbyReportsButton() {
        let button = UIButton()
        button.setTitle("Get Reports", for: .normal)
        button.addTarget(self, action: #selector(self.getNearbyReportsForMapBounds), for: .touchUpInside)
        button.setTitleColor(ThemeColors.default.textPrimary, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40),
            button.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: navBarView.trailingAnchor, constant: -15)
        ])
    }
    
    @objc func getNearbyReportsForMapBounds() {
        let visibleCoordinateBounds = mapView.visibleCoordinateBounds
        let bound = MapplsRectangularRegion(topLeft: visibleCoordinateBounds.ne, bottomRight: visibleCoordinateBounds.sw)
        let option = MapplsNearbyReportOptions(bound: bound)
        activityIndicator.startAnimating()
        APIManager.getNearbyReports(option: option) { response in
            if let response = response, let reports = response.reports {
                self.mapView.removeAnnotations(self.mapView.annotations ?? [])
                
                var annotations: [MGLPointAnnotation] = []
                reports.forEach({ reports in
                    let annotation: MGLPointAnnotation = MGLPointAnnotation()
                    annotation.coordinate = .init(latitude: Double(reports.latitude ?? 0.0), longitude: Double(reports.longitude ?? 0.0))
                    annotation.title = reports.addedByName
                    self.mapView.addAnnotation(annotation)
                    annotations.append(annotation)
                })
                self.mapView.showAnnotations(annotations, animated: true)
            }
            self.activityIndicator.stopAnimating()
        } failure: { error in
            print(error.localizedDescription)
            self.activityIndicator.stopAnimating()
        }
    }
}

extension RestAPIViewController: NavigationProtocol {
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension RestAPIViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        switch restAPISubOptionSelected {
        case .reverseGeocodeAPI:
            let geoCodeIcon = UIImageView(image: UIImage(named: "chooseLocationMarker"))
            geoCodeIcon.contentMode = .scaleAspectFit
            geoCodeIcon.translatesAutoresizingMaskIntoConstraints = false
            mapView.addSubview(geoCodeIcon)
            
            NSLayoutConstraint.activate([
                geoCodeIcon.heightAnchor.constraint(equalToConstant: 50),
                geoCodeIcon.widthAnchor.constraint(equalToConstant: 50),
                geoCodeIcon.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
                geoCodeIcon.centerXAnchor.constraint(equalTo: mapView.centerXAnchor)
            ])
        case .nearbyAPI:
            self.setTextfieldBtn(with: "Enter Category")
        case .placeDetails:
            let placeOptions = MapplsPlaceDetailOptions(mapplsPin: "mmi000", withRegion: .india)
            APIManager.placeDetail(option: placeOptions) { placeDetail in
                if let placeDetail = placeDetail {
                    var keyValData: [KeyValueHashable] = []
                    let encoder = JSONEncoder()
                    let data = try? encoder.encode(placeDetail)
                    guard let data = data else {return}
                    let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
                    guard let dictionary = json as? [String : AnyObject] else {
                        return
                    }
                    let _ = dictionary.keys.map({ key in
                        if let value = dictionary[key] {
                            if let valueStr = value as? String {
                                keyValData.append(.init(key: key, value: valueStr))
                            }else if let valueNum = value as? Double {
                                keyValData.append(.init(key: key, value: String(valueNum)))
                            }else {
                                keyValData.append(.init(key: key, value: ""))
                            }
                        }
                    })
                    self.setPlaceSheet(with: keyValData)
                    mapView.setCenter(.init(latitude: Double(truncating: placeDetail.latitude ?? 0.0), longitude: Double(truncating: placeDetail.longitude ?? 0.0)), zoomLevel: 18, animated: true)
                }
            } failure: { error in
                print(error.localizedDescription)
            }
        case .geocodeAPI:
            self.setTextfieldBtn(with: "Enter Address")
        case .routingAPI:
            self.setLongTapInfoLbl()
            self.addRouteClearBtn()
            self.addLongTapGestureToMap()
        case .drivingDistanceTimeMatrixAPI:
            let centerLocation: CLLocation = CLLocation(latitude: 28.543014, longitude: 77.242342)
            let point1: CLLocation = CLLocation(latitude: 28.520638, longitude: 77.201959)
            let point2: CLLocation = CLLocation(latitude: 28.511810, longitude: 77.252773)
            let distanceMatrixOptions = MapplsDrivingDistanceMatrixOptions(center: centerLocation, points: [point1, point2])
            distanceMatrixOptions.profileIdentifier = .driving
            distanceMatrixOptions.resourceIdentifier = .eta
            APIManager.getDistanceTimeMatrix(option: distanceMatrixOptions) { results in
                if let results = results, let durations = results.durations?[0], let distances = results.distances?[0] {
                    let centerAnnotation: MGLPointAnnotation = MGLPointAnnotation()
                    centerAnnotation.coordinate = centerLocation.coordinate
                    mapView.addAnnotation(centerAnnotation)
                    
                    let point1Ann: MGLPointAnnotation = MGLPointAnnotation()
                    point1Ann.coordinate = point1.coordinate
                    mapView.addAnnotation(point1Ann)
                    
                    let point2Ann: MGLPointAnnotation = MGLPointAnnotation()
                    point2Ann.coordinate = point2.coordinate
                    mapView.addAnnotation(point2Ann)
                    
                    mapView.showAnnotations([centerAnnotation, point2Ann, point1Ann], animated: true)
                    
                    let pointCount = distanceMatrixOptions.points?.count ?? -1
                    var drivingDistTimeDesc: String = ""
                    for i in 0..<pointCount {
                        if i < durations.count && i < distances.count {
                            drivingDistTimeDesc += "ETA \(i): duration: \(durations[i]) distance: \(distances[i])\n"
                        }
                    }
                    self.setPlaceAddressView(placeName: "Driving distance and time:", address: drivingDistTimeDesc)
                }
            } failure: { error in
                print(error.localizedDescription)
            }
        case .poiAlongRouteAPI:
            let waypoints = [
                Waypoint(coordinate: CLLocationCoordinate2D(latitude: 28.551078, longitude: 77.268968), name: "Mappls"),
                Waypoint(coordinate: CLLocationCoordinate2D(latitude: 28.565065, longitude: 77.234193), name: "Moolchand")
            ]
            
            let options = RouteOptions(waypoints: waypoints, resourceIdentifier: .routeAdv, profileIdentifier: .driving)
            options.includesSteps = true
            APIManager.getRoute(options: options) { routes, waypoints in
                if let route = routes?.first {
                    let polyline = MGLPolylineFeature(coordinates: route.coordinates ?? [], count: route.coordinateCount)
                    mapView.addAnnotation(polyline)
                    mapView.showAnnotations([polyline], animated: true)
                    self.currentRouteOnMap = route
                    self.setTextfieldBtn(with: "Enter Category")
                }
            } failure: { error in
                print(error.localizedDescription)
            }
        case .nearbyReportAPI:
            guard let location = mapView.userLocation?.coordinate ?? CLLocationManager().location?.coordinate else {return}
            mapView.setCenter(location, zoomLevel: 14, animated: false)
            self.addGetNearbyReportsButton()
            self.getNearbyReportsForMapBounds()
        case .weatherConditionAPI:
            self.addGetWeatherInfoTapGesture()
            
            let location = CLLocation(latitude: 28.787, longitude: 77.7873)
            let options = MapplsWeatherRequestOptions(location: location)
            options.unitType = .day
            options.unit = "5"
            options.theme = .light
            
            APIManager.currentWeatherConditionAPI(option: options) { response in
                if let response = response, let weatherData = response.data {
                    let annotation = MGLPointAnnotation()
                    annotation.coordinate = location.coordinate
                    mapView.addAnnotation(annotation)
                    mapView.setCenter(location.coordinate, zoomLevel: 15, animated: true)
                    
                    var keyValData: [KeyValueHashable] = []
                    let encoder = JSONEncoder()
                    let data = try? encoder.encode(weatherData)
                    guard let data = data else {return}
                    let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
                    guard let dictionary = json as? [String : AnyObject] else {
                        return
                    }
                    let _ = dictionary.keys.map({ key in
                        if let value = dictionary[key] {
                            if let valueDict = value as? NSDictionary {
                                let _ = valueDict.map { (key: Any, value: Any) in
                                    if let key = key as? String, !key.contains("Icon"), !key.contains("URL"), let value = valueDict[key] {
                                        if let numValue = value as? Double {
                                            keyValData.append(.init(key: key, value: String(numValue)))
                                        }else if let stringValue = value as? String {
                                            keyValData.append(.init(key: key, value: stringValue))
                                        }else {
                                            keyValData.append(.init(key: key, value: ""))
                                        }
                                    }
                                }
                            }
                        }
                    })
                    self.setPlaceSheet(with: keyValData)
                }
            } failure: { error in
                print(error.localizedDescription)
            }
        case .hateosNearbyAPI:
            break
        case .predictiveDirection:
            break
        case .predictiveDistance:
            break
        default:
            break
        }
    }
    
    func mapView(_ mapView: MGLMapView, didTapPlaceWithMapplsPin mapplsPin: String?) {
        if restAPISubOptionSelected == .placeDetails {
            APIManager.placeDetail(option: .init(mapplsPin: mapplsPin ?? "", withRegion: .india)) { placeDetail in
                if let placeDetail = placeDetail {
                    var keyValData: [KeyValueHashable] = []
                    let encoder = JSONEncoder()
                    let data = try? encoder.encode(placeDetail)
                    guard let data = data else {return}
                    let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
                    guard let dictionary = json as? [String : AnyObject] else {
                        return
                    }
                    let _ = dictionary.keys.map({ key in
                        if let value = dictionary[key] {
                            if let valueStr = value as? String {
                                keyValData.append(.init(key: key, value: valueStr))
                            }else if let valueNum = value as? Double {
                                keyValData.append(.init(key: key, value: String(valueNum)))
                            }else {
                                keyValData.append(.init(key: key, value: ""))
                            }
                        }
                    })
                    self.setPlaceSheet(with: keyValData)
                }
            } failure: { error in
                print(error.localizedDescription)
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        if restAPISubOptionSelected == .reverseGeocodeAPI {
            let revOptions = MapplsReverseGeocodeOptions(coordinate: mapView.centerCoordinate, withRegion: .india)
            APIManager.reverseGeocode(options: revOptions) { placemarks in
                if let placemarks = placemarks, let placemark = placemarks.first {
                    var keyVal: [KeyValueHashable] = []
                    let encoder: JSONEncoder = JSONEncoder()
                    let data = try? encoder.encode(placemark)
                    guard let data = data else {return}
                    
                    let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
                    guard let dictionary = json as? [String: AnyObject] else {return}
                    let _ = dictionary.keys.map({ key in
                        if let value = dictionary[key] {
                            if let numValue = value as? Double {
                                keyVal.append(.init(key: key, value: String(numValue)))
                            }else if let stringValue = value as? String {
                                keyVal.append(.init(key: key, value: stringValue))
                            }else {
                                keyVal.append(.init(key: key, value: ""))
                            }
                        }
                    })
                    self.setPlaceSheet(with: keyVal)
                }
            } failure: { error in
                print(error.localizedDescription)
            }
        }
    }
}

extension RestAPIViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view?.backgroundColor = theme.backgroundPrimary
            self.infoTableView?.backgroundColor = theme.backgroundPrimary
            self.navBarTextfieldButton?.setTitleColor(theme.textPrimary, for: .normal)
        }
    }
}

extension MapplsCongestionInfo {
    func toKeyValuePairs() -> [KeyValue] {
        var keyValData: [KeyValue] = []
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            if let key = child.label {
                if let value = child.value as? Double {
                    keyValData.append(KeyValue(key: key, value: String(value)))
                } else if let value = child.value as? String {
                    keyValData.append(KeyValue(key: key, value: value))
                } else {
                    keyValData.append(KeyValue(key: key, value: ""))
                }
            }
        }
        
        return keyValData
    }
}

struct KeyValue {
    let key: String
    let value: String
}

