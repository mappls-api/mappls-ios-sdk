//
//  marker.swift
//  MapplsSDKDemo
//
//  Created by rento on 23/01/25.
//

import UIKit
import MapplsMap

class GeoJSONViewController: UIViewController {
    
    var geoJSONSubOptionSelected: SubOptionsEnum!
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
        navBarView = NavigationBarView(title: geoJSONSubOptionSelected.rawValue)
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

extension GeoJSONViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        switch geoJSONSubOptionSelected {
        case .plotMarker:
            guard let url = Bundle.main.url(forResource: "Marker", withExtension: "geojson"), let data = try? Data(contentsOf: url) else {return}
            drawMarker(data: data)
        case .plotPolyline:
            guard let url = Bundle.main.url(forResource: "polyline", withExtension: "geojson"), let data = try? Data(contentsOf: url) else {return}
            drawPolyline(data: data)
        case .plotPolygon:
            guard let url = Bundle.main.url(forResource: "polygon", withExtension: "geojson"), let data = try? Data(contentsOf: url) else {return}
            drawPolygon(data: data)
        default:
            break
        }
    }
    
    func drawMarker(data: Data) {
        guard let style = mapView.style, let feature = try? MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as? MGLPointFeature else { return }

        let source = MGLShapeSource(identifier: "markerSource", shape: feature, options: nil)
        style.addSource(source)
        
        let circleLayer = MGLCircleStyleLayer(identifier: "circleLayerIdentifier", source: source)
        
        circleLayer.circleColor = NSExpression(forConstantValue: UIColor.red)
        circleLayer.circleRadius = NSExpression(forConstantValue: 6)
        circleLayer.circleStrokeWidth = NSExpression(forConstantValue: 2)
        circleLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.black)
        
        style.addLayer(circleLayer)
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: 28.543253, longitude: 77.261647), zoomLevel: 11, animated: false)
    }
    
    func drawPolygon(data: Data) {
        guard let style = mapView.style, let feature = try? MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as? MGLPolygonFeature else { return }
        
        let source = MGLShapeSource(identifier: "sourceIdentifier", shape: feature, options: nil)
        style.addSource(source)
        
        let polygonLayer = MGLFillStyleLayer(identifier: "station-boundry", source: source)
        polygonLayer.fillColor = NSExpression(forConstantValue: UIColor.red)
        polygonLayer.fillOpacity = NSExpression(forConstantValue: 0.5)
        polygonLayer.fillOutlineColor = NSExpression(forConstantValue: UIColor.black)
        
        style.addLayer(polygonLayer)
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: 28.543253, longitude: 77.261647), zoomLevel: 13, animated: false)
    }
    
    func drawPolyline(data: Data) {
        guard let style = mapView.style, let feature = try? MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as? MGLPolylineFeature else { return }
        
        let source = MGLShapeSource(identifier: "sourceIdentifier", shape: feature, options: nil)
        style.addSource(source)
        
        let lineLayer = MGLLineStyleLayer(identifier: "lineIdentifier", source: source)
        lineLayer.lineColor = NSExpression(forConstantValue: UIColor.red)
        lineLayer.lineWidth = NSExpression(forConstantValue: 5)
        
        style.addLayer(lineLayer)
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: 28.543253, longitude: 77.261647), zoomLevel: 11, animated: false)
    }
}

extension GeoJSONViewController: NavigationProtocol {
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension GeoJSONViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
        }
    }
}

