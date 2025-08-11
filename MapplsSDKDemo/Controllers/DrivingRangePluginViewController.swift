//
//  DrivingRangePluginViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 27/01/25.
//

import UIKit
import MapplsMap
import MapplsDrivingRangePlugin
import MapplsUIWidgets

class DrivingRangePluginViewController: UIViewController {

    var mapView: MapplsMapView!
    var navBarView: NavigationBarView!
    var drivingRangePlugin: MapplsDrivingRange!
    var activityIndicator: UIActivityIndicatorView!
    var mapCenterBtn: UIButton!
    var segmentView: CustomSegmentControl!
    var drivingRangeSettingsView: DrivingRangeSettingsView!
    var settingsBgCoverView: UIView!
    var drivingOptions: MapplsDrivingRangeOptions?
    var polygonFillColor: UIColor = .red
    var data: [DrivingRangeSettingsHashable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        navBarView = NavigationBarView(title: SubOptionsEnum.drivingRangePlugin.rawValue)
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
        mapView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mapView.zoomLevel = 5
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(mapView, belowSubview: navBarView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        self.drivingRangePlugin = MapplsDrivingRange(mapView: self.mapView)
        self.drivingRangePlugin.delegate = self
        
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
       
        segmentView = CustomSegmentControl(items: ["Driving Range", "Setting"])
        segmentView.selectedSegmentIndex = 0
        segmentView.addTarget(self, action: #selector(self.segmentViewValueChanged), for: .valueChanged)
        segmentView.layer.cornerCurve = .continuous
        segmentView.radius = 21
        segmentView.layer.borderWidth = 1
        segmentView.layer.masksToBounds = true
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentView)
        
        NSLayoutConstraint.activate([
            segmentView.widthAnchor.constraint(equalToConstant: 300),
            segmentView.heightAnchor.constraint(equalToConstant: 40),
            segmentView.topAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: 15),
            segmentView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
       
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        settingsBgCoverView = UIView()
        settingsBgCoverView.layer.opacity = 0.0
        settingsBgCoverView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(settingsBgCoverView, belowSubview: navBarView)
        
        NSLayoutConstraint.activate([
            settingsBgCoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsBgCoverView.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            settingsBgCoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsBgCoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        drivingRangeSettingsView = DrivingRangeSettingsView()
        drivingRangeSettingsView.delegate = self
        drivingRangeSettingsView.tableView.delegate = self
        drivingRangeSettingsView.layer.opacity = 0.0
        drivingRangeSettingsView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(drivingRangeSettingsView, belowSubview: segmentView)
        
        NSLayoutConstraint.activate([
            drivingRangeSettingsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            drivingRangeSettingsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            drivingRangeSettingsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            drivingRangeSettingsView.topAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: 30)
        ])
        
        data.append(.switchCell(.init(title: "Set as Current Location")))
        data.append(.keyboardInputCell(.init(title: "Location", saveBtnTitle: "Save Location", isLatLonInput: true)))
        data.append(.radioButtonCell(.init(title: "Range Type", radioItems: ["Time (in min.)", "Distance (in km.)"], selectedItem: "Time (in min.)")))
        data.append(.keyboardInputCell(.init(title: "Contour", saveBtnTitle: "Save Contour Value")))
        data.append(.radioButtonCell(.init(title: "Color", radioItems: ["Red", "Green", "Blue"], selectedItem: "Red")))
        data.append(.keyboardInputCell(.init(title: "Driving Profile", saveBtnTitle: "Save Driving Profile")))
        data.append(.switchCell(.init(title: "Show Location")))
        data.append(.switchCell(.init(title: "Show Polygon")))
        data.append(.keyboardInputCell(.init(title: "Denoise", saveBtnTitle: "Save Denoise")))
        data.append(.keyboardInputCell(.init(title: "Generalize", saveBtnTitle: "Save Generalize")))
        data.append(.radioButtonCell(.init(title: "Speed Type", radioItems: ["Optimal", "Predictive"], selectedItem: "Optimal")))
        
        drivingRangeSettingsView.data = data
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    @objc func segmentViewValueChanged() {
        if segmentView.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.15) {
                self.drivingRangeSettingsView.layer.opacity = 0.0
            } completion: { _ in
                UIView.animate(withDuration: 0.15) {
                    self.settingsBgCoverView.layer.opacity = 0.0
                }
            }
        }else {
            UIView.animate(withDuration: 0.15) {
                self.settingsBgCoverView.layer.opacity = 1.0
            } completion: { _ in
                UIView.animate(withDuration: 0.15) {
                    self.drivingRangeSettingsView.layer.opacity = 1.0
                }
            }
        }
    }
    
    @objc func centerMap() {
        if let coordinate = mapView.userLocation?.coordinate ?? CLLocationManager().location?.coordinate {
            mapView.setCenter(coordinate, zoomLevel: 18, animated: true)
        }
    }
    
    func updateDrivingRange(drivingOptions: MapplsDrivingRangeOptions) {
//        self.drivingRangePlugin.isSetMapBoundForDrivingRangeOnLaunch = false
        drivingRangePlugin.clearDrivingRangeFromMap()
        self.drivingRangePlugin.getAndPlotDrivingRange(options: drivingOptions)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            self.drivingRangeSettingsView.setBottomInset(to: keyboardHeight)
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        self.drivingRangeSettingsView.setBottomInset(to: 0.0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }
}

extension DrivingRangePluginViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let location = CLLocation(latitude: 28.612972, longitude: 77.233529)
        let contours = [MapplsDrivingRangeContour(value: 15)]
        let rangeInfo = MapplsDrivingRangeRangeTypeInfo(rangeType: .time, contours: contours)
        let speedInfo1 = MapplsDrivingRangeOptimalSpeed()
        let drivingRangeOptions = MapplsDrivingRangeOptions(location: location, rangeTypeInfo: rangeInfo, speedTypeInfo: speedInfo1)
        drivingRangeOptions.isShowLocations = false
        self.drivingOptions = drivingRangeOptions
        self.drivingRangePlugin.getAndPlotDrivingRange(options: drivingRangeOptions)
    }
}

extension DrivingRangePluginViewController: MapplsDrivingRangeDelegate {
    func drivingRange(_ plugin: MapplsDrivingRange, didFailToGetAndPlotDrivingRange error: Error) {
        print("drivingRange: didFailToGetAndPlotDrivingRange: \(error.localizedDescription)")
        let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (alertAction) in
            self.dismiss(animated: false, completion: nil)
        }))
        self.present(alertController, animated: false, completion: nil)
        activityIndicator.stopAnimating()
    }
    
    func drivingRangeDidSuccessToGetAndPlotDrivingRange(_ plugin: MapplsDrivingRange) {
        activityIndicator.stopAnimating()
    }
    
    func drivingRangePolygonStyleLayer(_ plugin: MapplsDrivingRange) -> MGLFillStyleLayer? {
        let fillLayer = MGLFillStyleLayer(identifier: "Random", source: MGLShapeSource(identifier: "random"))
        fillLayer.fillColor = NSExpression(forConstantValue: polygonFillColor)
        fillLayer.fillOpacity = NSExpression(forConstantValue: 0.5)
        return fillLayer
    }

    func drivingRangePolylineStyleLayer(_ plugin: MapplsDrivingRange) -> MGLLineStyleLayer? {
        let lineLayer = MGLLineStyleLayer(identifier: "rail-line", source: MGLShapeSource(identifier: "rail-line"))
        lineLayer.lineColor = NSExpression(forConstantValue: UIColor.gray)
        lineLayer.lineWidth = NSExpression(forConstantValue: 5)
        return lineLayer
    }
}

extension DrivingRangePluginViewController: NavigationProtocol {
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension DrivingRangePluginViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
            self.segmentView.selectedSegmentTintColor = theme.accentBrandPrimary
            self.segmentView.backgroundColor = theme.backgroundSecondary
            self.segmentView.layer.borderColor = theme.strokeBorder.cgColor
            self.settingsBgCoverView.backgroundColor = theme.backgroundPrimary
        }
    }
}

extension DrivingRangePluginViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension DrivingRangePluginViewController: DrivingSettingsDelegate {
    func didSetAsCurrentLocation(withValue: Bool) async {
        
    }
    
    func locationDidSet(withValue: CLLocation) {
        guard let drivingOptions = drivingOptions else {return}
        drivingOptions.location = withValue
        updateDrivingRange(drivingOptions: drivingOptions)
    }
    
    func rangeTypeDidChange(withValue: MapplsDrivingRangeRangeType) async {
        guard let drivingOptions = drivingOptions else {return}
        drivingOptions.rangeTypeInfo = .init(rangeType: withValue, contours: drivingOptions.rangeTypeInfo?.contours ?? [])
        updateDrivingRange(drivingOptions: drivingOptions)
    }
    
    func contourDidSet(withValue: MapplsAPIKit.MapplsDrivingRangeContour) async {
        guard let drivingOptions = drivingOptions, let rangeType = drivingOptions.rangeTypeInfo?.rangeType else {return}
        drivingOptions.rangeTypeInfo = .init(rangeType: rangeType, contours: [withValue])
        updateDrivingRange(drivingOptions: drivingOptions)
    }
    
    func colorDidSet(withValue: UIColor) async {
        guard let drivingOptions = drivingOptions else {return}
        polygonFillColor = withValue
        updateDrivingRange(drivingOptions: drivingOptions)
    }
    
    func drivingProfileDidSet(withValue: MapplsDirectionsProfileIdentifier) async {
        guard let drivingOptions = drivingOptions else {return}
        drivingOptions.drivingProfile = withValue
        updateDrivingRange(drivingOptions: drivingOptions)
    }
    
    func showLocation(isEnabled: Bool) async {
        guard let drivingOptions = drivingOptions else {return}
        drivingOptions.isShowLocations = isEnabled
        updateDrivingRange(drivingOptions: drivingOptions)
    }
    
    func showPolygon(isEnabled: Bool) async {
        guard let drivingOptions = drivingOptions else {return}
        drivingOptions.isForPolygons = isEnabled
        updateDrivingRange(drivingOptions: drivingOptions)
    }
    
    func denoiseDidSet(withValue: NSNumber) async {
        guard let drivingOptions = drivingOptions else {return}
        drivingOptions.denoise = withValue
        updateDrivingRange(drivingOptions: drivingOptions)
    }
    
    func generalizeDidSet(withValue: NSNumber) async {
        guard let drivingOptions = drivingOptions else {return}
        drivingOptions.generalize = withValue
        updateDrivingRange(drivingOptions: drivingOptions)
    }
    
    func speedTypeDidSet(withValue: MapplsDrivingRangeSpeed) async {
        guard let drivingOptions = drivingOptions else {return}
        drivingOptions.speedTypeInfo = withValue
        updateDrivingRange(drivingOptions: drivingOptions)
    }
    
    func searchLocationButtonPressed() {
        let autoSearch = MapplsAutocompleteViewController()
        autoSearch.delegate = self
        present(autoSearch, animated: true)
    }
}

extension DrivingRangePluginViewController: MapplsAutocompleteViewControllerDelegate {
    func didAutocomplete(viewController: MapplsUIWidgets.MapplsAutocompleteViewController, withSuggestion suggestion: MapplsAPIKit.MapplsSearchPrediction) {
        
    }
    
    func didAutocomplete(viewController: MapplsUIWidgets.MapplsAutocompleteViewController, withFavouritePlace place: MapplsUIWidgets.MapplsUIWidgetAutosuggestFavouritePlace) {
        
    }
    
    func didFailAutocomplete(viewController: MapplsUIWidgets.MapplsAutocompleteViewController, withError error: NSError) {
        
    }
    
    func wasCancelled(viewController: MapplsUIWidgets.MapplsAutocompleteViewController) {
        
    }
    
    func didAutocomplete(viewController: MapplsAutocompleteViewController, withPlace place: MapplsAtlasSuggestion, resultType type: MapplsAutosuggestResultType) {
        viewController.dismiss(animated: true)
        let data = data[1]
        switch data {
        case .keyboardInputCell(let input):
            input.inputs[0] = place.latitude?.stringValue ?? ""
            input.inputs[1] = place.longitude?.stringValue ?? ""
            locationDidSet(withValue: .init(latitude: CLLocationDegrees(truncating: place.latitude ?? 0.0), longitude: CLLocationDegrees(truncating: place.longitude ?? 0.0)))
            var snapshot = drivingRangeSettingsView.dataSource.snapshot()
            snapshot.reloadItems([data])
            drivingRangeSettingsView.dataSource.apply(snapshot)
        default:
            break
        }
    }
}
