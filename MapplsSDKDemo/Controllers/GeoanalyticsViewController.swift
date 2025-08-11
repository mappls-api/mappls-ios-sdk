//
//  GeoanalyticsViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 24/01/25.
//

import UIKit
import MapplsGeoanalytics
import FittedSheets

class GeoanalyticsViewController: UIViewController, MapplsGeoanalyticsPluginDelegate {
    var mapView: MapplsMapView!
    var layerArray = [MapplsGeoanalyticsLayerRequest]()
    var listingAPIRequestArray = [GeoanalyticsListingAPIRequest]()
    var geoanalyticsPlugin : MapplsGeoanalyticsPlugin!
    var navBarView: NavigationBarView!
    var sheet: SheetViewController?
    var arrayOfCoordinate = [CLLocationCoordinate2D]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        navBarView = NavigationBarView(title: SubOptionsEnum.geoanalytics.rawValue)
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
        self.view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let coordinate = CLLocationCoordinate2D(latitude: 28.5354, longitude: 77.2639)
        addAnnotation(at: coordinate)
        
        mapView.setCenter(coordinate, animated: false)
        
        let coordinates = [
            CLLocationCoordinate2D(latitude: 28.551438, longitude: 77.265119),
            CLLocationCoordinate2D(latitude: 28.511438, longitude: 77.265119),
            CLLocationCoordinate2D(latitude: 28.521438, longitude: 77.265119),
            CLLocationCoordinate2D(latitude: 28.571438, longitude: 77.265119),
            CLLocationCoordinate2D(latitude: 28.551438, longitude: 77.265119),
            CLLocationCoordinate2D(latitude: 28.598438, longitude: 77.265119),
            CLLocationCoordinate2D(latitude: 28.518438, longitude: 77.265119),
            CLLocationCoordinate2D(latitude: 28.507438, longitude: 77.265119),
            CLLocationCoordinate2D(latitude: 28.547438, longitude: 77.262119),
        ]
        
        geoanalyticsPlugin = MapplsGeoanalyticsPlugin(mapView: mapView)
        geoanalyticsPlugin.delegate = self
        geoanalyticsPlugin.shouldShowPopupForGeoanalyticsLayer = true
        addPolyline(coordinates: coordinates)
        setUpSheet()
        
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    func setUpSheet() {
        var sheetOptions = SheetOptions()
        sheetOptions.useInlineMode = true
        
        let vc = GeoanalyticsSwitchCasesViewController()
        vc.delegate = self
        
        sheet = SheetViewController(controller: vc, sizes: [.percent(0.25), .percent(0.5), .percent(0.7)], options: sheetOptions)
        sheet?.allowGestureThroughOverlay = true
        sheet?.overlayColor = .clear
        sheet?.allowPullingPastMaxHeight = false
        sheet?.allowPullingPastMinHeight = false
        sheet?.dismissOnPull = false
        sheet?.dismissOnOverlayTap = false
        sheet?.handleScrollView(vc.switchCasesTableView)
        sheet?.animateIn(to: view, in: self)
    }
    
    func view(forGeoanalyticsInfo response: GeoanalyticsGetFeatureInfoResponse) -> UIView? {
        return nil
    }
    
    func addPolyline(coordinates: [CLLocationCoordinate2D]) {
        var coordinates = coordinates
        
        let mmiPolyline = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        mapView.addAnnotation(mmiPolyline)
    }
    
    func addAnnotation(at coordinate: CLLocationCoordinate2D) {
        let marker = MGLPointAnnotation()
        marker.coordinate = coordinate
        mapView.addAnnotation(marker)
    }
    
    func converToCoordinate(location: String) -> CLLocationCoordinate2D? {
        let locationString = location.split(separator: ",")
        if locationString.count < 2 {
            return nil
        } else if locationString.count == 2 {
            let latitude: Double = Double(locationString.last!) ?? 0.0
            let longitue: Double = Double(locationString.first!) ?? 0.0
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitue))
            print("coordinate: \(latitude), \(longitue)")
            return coordinate
        } else {
            return nil
        }
    }
    
    func switchChanged(request: (GeoanalyticsListingAPIRequest, MapplsGeoanalyticsLayerRequest), isOn: Bool) {
        arrayOfCoordinate.removeAll()
        let requestItem = request.1
        let listingRequest = request.0
        if isOn {
            let res = MapplsGeoanalyticsListingManager.shared()
            res.getListingInfo(listingRequest) { (response, error) in
                if (error != nil) {
                    
                } else {
                    if let response = response?.results?.getAttrValues {
                        for i in response {
                            let attrValues : GeoanalyticsAttributedValues = i as! GeoanalyticsAttributedValues
                            if  let innerAttrValue = attrValues.attributedValues {
                                let arrayOfAttrValue = innerAttrValue as NSArray
                                for attr in arrayOfAttrValue {
                                    if let dict = attr as? [String: String] {
                                        let bbox: String = dict["b_box"] ?? ""
                                        let bbox_withoutExtraString = bbox.replacingOccurrences(of: "[BOX()]", with: "",options: .regularExpression)
                                        let bboxCoordinates = bbox_withoutExtraString.split(separator: ",")
                                        for coor in bboxCoordinates {
                                            let aa = "\(coor.replacingOccurrences(of: " ", with: ",",options: .regularExpression))"
                                            if let coordinate = self.converToCoordinate(location: aa) {
                                                self.arrayOfCoordinate.append(coordinate)
                                                print(coordinate)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.geoanalyticsPlugin.showGeoanalyticsLayer(requestItem)
                    
                    if self.arrayOfCoordinate.count > 0 {
                        self.mapView.setVisibleCoordinateBounds(self.generateCoordinatesBounds(forCoordinates: self.arrayOfCoordinate), animated: false)
                    }
                    
                }
            }
            
        } else {
            geoanalyticsPlugin.removeGeoanalyticsLayer(requestItem)
        }
    }
    
    func didGetFeatureInfoResponse(_ featureInfoResponse: GeoanalyticsGetFeatureInfoResponse) {
        
    }
    
    func generateCoordinatesBounds(forCoordinates coordinates: [CLLocationCoordinate2D]) -> MGLCoordinateBounds {

        var maxN = CLLocationDegrees(), maxS = CLLocationDegrees() , maxE = CLLocationDegrees() , maxW = CLLocationDegrees()
        for coordinates in  coordinates {
            if coordinates.latitude >= maxN || maxN == 0 { maxN = coordinates.latitude }
            if coordinates.latitude <= maxS || maxS == 0 { maxS = coordinates.latitude }
            if coordinates.longitude >= maxE || maxE == 0 { maxE = coordinates.longitude }
            if coordinates.longitude <= maxW || maxW == 0{ maxW = coordinates.longitude }
        }

        let offset = 0.001
        let maxNE = CLLocationCoordinate2D(latitude: maxN + offset, longitude: maxE + offset)
        let maxSW =  CLLocationCoordinate2D(latitude: maxS - offset, longitude: maxW - offset)
        return MGLCoordinateBounds(sw: maxSW, ne: maxNE)
    }
}

extension GeoanalyticsViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
    }
}

extension GeoanalyticsViewController: NavigationProtocol {
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension GeoanalyticsViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
            self.sheet?.contentViewController.contentBackgroundColor = theme.backgroundPrimary.withAlphaComponent(0.95)
            self.sheet?.gripColor = theme.strokeBorder
        }
    }
}

extension GeoanalyticsViewController: GeoanalyticsSwitchChangeDelegate {
    func switchChangedValue(isOn: Bool, request: (GeoanalyticsListingAPIRequest, MapplsGeoanalyticsLayerRequest)) async {
        switchChanged(request: request, isOn: isOn)
    }
}
