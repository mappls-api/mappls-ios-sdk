//
//  PolylineOptionsShowcaseViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 16/01/25.
//

import UIKit
import MapplsMap
import MapplsAPIKit
import MapKit

precedencegroup ExponentiationPrecedence {
    associativity: right
    higherThan: MultiplicationPrecedence
}

infix operator ** : ExponentiationPrecedence

func ** (_ base: Double, _ exp: Double) -> Double {
    return pow(base, exp)
}

func ** (_ base: Float, _ exp: Float) -> Float {
    return pow(base, exp)
}

struct GreatCircle {
    
    let earthRadius = 6371000.0
    
    func discretizePoints(fromCoordinate: CLLocationCoordinate2D, toCoordinate: CLLocationCoordinate2D, discritizeDistance: Double = 50000) -> [CLLocationCoordinate2D] { //17000
        var fromLat = fromCoordinate.latitude
        var fromLon = fromCoordinate.longitude
        let toLat = toCoordinate.latitude
        let toLon = toCoordinate.longitude
        
        var pointsCoordinates = [fromCoordinate]
        var distance = getPointDistance(from: fromCoordinate, to: toCoordinate)
        if distance > 1500000 { print("Very big distance") }
        
        let coordinates2 = CLLocationCoordinate2DMake(toLat, toLon)
        while distance > discritizeDistance {
            
            let bearing = getBearingDegree(from: CLLocationCoordinate2DMake(fromLat, fromLon),
                                           to: CLLocationCoordinate2DMake(toLat, toLon))
            
            let destCoord = getDestinationCoordinates(coordinate: CLLocationCoordinate2DMake(fromLat, fromLon),
                                                      dist: discritizeDistance, bearing: bearing)
            
            fromLat = (destCoord.latitude).rounded(toPlaces: 6)
            fromLon = (destCoord.longitude).rounded(toPlaces: 6)
            
            pointsCoordinates.append(CLLocationCoordinate2DMake(fromLat, fromLon))
            
            distance = getPointDistance(from: CLLocationCoordinate2DMake(fromLat, fromLon),
                                        to: coordinates2)
        }
        pointsCoordinates.append(CLLocationCoordinate2DMake(toLat, toLon))
        
        return pointsCoordinates
    }
    
    func getPointDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        
        let fromLat = from.latitude.toRadians()
        let fromLon = from.longitude.toRadians()
        let toLat = to.latitude.toRadians()
        let toLon = to.longitude.toRadians()
        
        let latDiff = (toLat - fromLat)
        let lonDiff = (toLon - fromLon)
        
        let a = (sin(latDiff / 2) ** 2) + cos(fromLat) * cos(toLat) * (sin(lonDiff / 2) ** 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        let dist = c * earthRadius
        
        return dist
    }
    
    func getBearingDegree(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        
        let fromLat = from.latitude.toRadians()
        let fromLon = from.longitude.toRadians()
        let toLat = to.latitude.toRadians()
        let toLon = to.longitude.toRadians()
        
        let lonDiff = (toLon - fromLon)
        let a = sin(lonDiff) * cos(toLat)
        let b = cos(fromLat) * sin(toLat) - sin(fromLat) * cos(toLat) * cos(lonDiff)
        let brng_deg = atan2(a, b)
        
        let cleanAngle = cleanAngleDegree(angle: brng_deg.toDegrees())
        
        return cleanAngle
    }
    
    func cleanAngleDegree(angle: Double) -> Double {
        
        var cleanAngle = angle
        while cleanAngle >= 360 {
            cleanAngle -= 360
        }
        while cleanAngle < 0 {
            cleanAngle += 360
        }
        return cleanAngle
    }
    
    func getDestinationCoordinates(coordinate: CLLocationCoordinate2D, dist: Double, bearing: Double) -> CLLocationCoordinate2D {
        
        let lat = coordinate.latitude.toRadians()
        let lon = coordinate.longitude.toRadians()
        let inBearing = bearing.toRadians()
        
        var lat2 = asin(sin(lat) * cos(dist / earthRadius) + cos(lat) * sin(dist / earthRadius) * cos(inBearing))
        var lon2 = lon + atan2(sin(inBearing) * sin(dist / earthRadius) * cos(lat),cos(dist / earthRadius) - sin(lat) * sin(lat2))
        
        lat2 = lat2.toDegrees()
        lon2 = lon2.toDegrees()
        
        let coordinate = CLLocationCoordinate2DMake(lat2, lon2)
        return coordinate
    }
}

class PolylineViewController: UIViewController {
    
    var polylineSubOptionSelected: SubOptionsEnum!
    var navBarView: NavigationBarView!
    var mapView: MapplsMapView!
    var mapCenterBtn: UIButton!
    var activityIndicator: UIActivityIndicatorView!
    
    var polylinePlugin: PolylineLayerPlugin?
    var animationTimer: Timer?
    var polylineSource: MGLShapeSource?
    var polylineAnimatioCurrentIndex: Int = 1
    var route: Route?
    let coordinates: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 28.550834, longitude: 77.268918),
        CLLocationCoordinate2D(latitude: 28.551059, longitude: 77.268890),
        CLLocationCoordinate2D(latitude: 28.550938, longitude: 77.267641),
        CLLocationCoordinate2D(latitude: 28.551764, longitude: 77.267575),
        CLLocationCoordinate2D(latitude: 28.552068, longitude: 77.267599),
        CLLocationCoordinate2D(latitude: 28.553836, longitude: 77.267450),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        navBarView = NavigationBarView(title: polylineSubOptionSelected.rawValue)
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
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50)
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
    
    func setMapTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.mapTapped(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func mapTapped(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            let point = sender.location(in: mapView)
            let _ = polylinePlugin?.selectRoute(point: point)
        default:
            break
        }
    }
    
    @objc func animateLength() {
        guard let route = route, let coordinates = route.coordinates else {return}
        
        if polylineAnimatioCurrentIndex > coordinates.count {
            polylineAnimatioCurrentIndex = 1
            animationTimer?.invalidate()
            animationTimer = nil
            return
        }
        
        let updateCoordinates = Array(coordinates[0..<polylineAnimatioCurrentIndex])
        updatePolylineWithCoordinates(coordinates: updateCoordinates)
        polylineAnimatioCurrentIndex += 100
    }
    
    func updatePolylineWithCoordinates(coordinates: [CLLocationCoordinate2D]) {
        let polyline = MGLPolylineFeature(coordinates: coordinates, count: UInt(coordinates.count))
        polylineSource?.shape = polyline
    }
    
    func addInteriorPolygonOnMap() {
        let stepper = UIStepper()
        stepper.value = 100
        stepper.minimumValue = 10
        stepper.stepValue = 2
        stepper.maximumValue = 200
        stepper.addTarget(self, action: #selector(self.stepperValueChanged), for: .valueChanged)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(stepper)
        
        NSLayoutConstraint.activate([
            stepper.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            stepper.heightAnchor.constraint(equalToConstant: 40),
            stepper.widthAnchor.constraint(equalToConstant: 100),
            stepper.trailingAnchor.constraint(equalTo: navBarView.trailingAnchor, constant: -15)
        ])
    }
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        if let mapStyle = self.mapView.style {
            if let source = mapStyle.source(withIdentifier: "interiorPolygonSourceIdentifier") as? MGLShapeSource {
                let sourceFeatures = getSourceFeatures(coordinate:CLLocationCoordinate2DMake(28.550834, 77.268918), radius: sender.value)
                source.shape = sourceFeatures
                if let shape = sourceFeatures.interiorPolygons?.first {
                    let shapeCam = mapView.cameraThatFitsShape(shape, direction: CLLocationDirection(0), edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
                    mapView.setCamera(shapeCam, animated: false)
                }
            }
        }
    }
    
    func getSourceFeatures(coordinate: CLLocationCoordinate2D, radius: Double) -> MGLPolygonFeature {
        let circleCoordinates = Utility.polygonCircleForCoordinate(coordinate: coordinate, withMeterRadius: radius)

        let holePolygon = MGLPolygonFeature(coordinates: circleCoordinates, count: UInt(circleCoordinates.count))
        let visibleQuadCoordinates = MGLCoordinateQuadFromCoordinateBounds(MGLCoordinateBounds(sw: CLLocationCoordinate2DMake(6, 60), ne: CLLocationCoordinate2DMake(35,100)))
        let visibleCoordinates = [visibleQuadCoordinates.topLeft, visibleQuadCoordinates.topRight, visibleQuadCoordinates.bottomRight, visibleQuadCoordinates.bottomLeft]
        let polygonFeature = MGLPolygonFeature(coordinates: visibleCoordinates, count: UInt(visibleCoordinates.count), interiorPolygons: [holePolygon])
        return polygonFeature
    }
    
    func addAddPolylineButton() {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(ThemeColors.default.accentBrandPrimary, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.drawPolylineButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalToConstant: 80),
            button.centerYAnchor.constraint(equalTo: navBarView.safeAreaLayoutGuide.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: navBarView.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc func drawPolylineButton(_ sender: UIButton) {
        switch polylineSubOptionSelected {
        case .annotationPolyline:
            if sender.titleLabel?.text == "Add" {
                sender.setTitle("Remove", for: .normal)
                let polyline = MGLPolyline(coordinates: coordinates, count: UInt(coordinates.count))
                mapView.addAnnotation(polyline)
                mapView.showAnnotations([polyline], animated: true)
            }else{
                sender.setTitle("Add", for: .normal)
                mapView.removeAnnotations(mapView.annotations ?? [])
            }
        case .polylineWithDifferentColors:
            if sender.titleLabel?.text == "Add" {
                sender.setTitle("Remove", for: .normal)
                guard let style = mapView.style else {return}
                let stops = [0: UIColor.red,
                             0.1: UIColor.yellow,
                             0.3: UIColor.green,
                             0.5: UIColor.cyan,
                             0.7: UIColor.systemBlue,
                             1: UIColor.blue]
                
                let sourceFeatures = MGLPolylineFeature(coordinates: coordinates, count: UInt(coordinates.count))
                let edgePadding = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)
                let camera = mapView.cameraThatFitsCoordinateBounds(sourceFeatures.overlayBounds, edgePadding: edgePadding)
                mapView.setCamera(camera, animated: true)
                
                var source: MGLShapeSource = .init(identifier: "")
                if let existingSource = style.source(withIdentifier: "lineSourceIdentifier") as? MGLShapeSource {
                    source = existingSource
                }else {
                    let sourceOptions: [MGLShapeSourceOption: Any] = [.lineDistanceMetrics: true]
                    source = MGLShapeSource(identifier: "lineSourceIdentifier", shape: sourceFeatures, options: sourceOptions)
                    style.addSource(source)
                }
                
                let polylineLayer = MGLLineStyleLayer(identifier: "lineLayerIdentifier", source: source)
                polylineLayer.lineWidth = NSExpression(forConstantValue: 8)
                polylineLayer.lineGradient = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($lineProgress, 'linear', nil, %@)", stops)
                style.addLayer(polylineLayer)
            }else{
                sender.setTitle("Add", for: .normal)
               
                if let layer = mapView.style?.layer(withIdentifier: "lineLayerIdentifier") {
                    mapView.style?.removeLayer(layer)
                }
            }
        case .polygon:
            if sender.titleLabel?.text == "Add" {
                sender.setTitle("Remove", for: .normal)
                var coordinates = [
                    CLLocationCoordinate2D(latitude: 28.551334, longitude: 77.268918),
                    CLLocationCoordinate2D(latitude: 28.558059, longitude: 77.268890),
                    CLLocationCoordinate2D(latitude: 28.555068, longitude: 77.267599),
                    CLLocationCoordinate2D(latitude: 28.550068, longitude: 77.267599)
                ]
                let polygon = MGLPolygon(coordinates: &coordinates, count:UInt(coordinates.count))
                mapView.addAnnotation(polygon)
                mapView.showAnnotations([polygon], animated: true)
            }else {
                sender.setTitle("Add", for: .normal)
                mapView.removeAnnotations(mapView.annotations ?? [])
            }
        case .semicirclePolyline:
            if sender.titleLabel?.text == "Add" {
                sender.setTitle("Remove", for: .normal)
                guard let style = mapView.style else {return}
                
                let center = CLLocationCoordinate2D(latitude: 28.551334, longitude: 77.268918)
                let semicircleCoords = Utility.createSemicirclePolyline(center: center, radius: 500, startAngle: 0, endAngle: 180)
                
                let sourceFeatures = MGLPolylineFeature(coordinates: semicircleCoords, count: UInt(semicircleCoords.count))
                let edgePadding = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)
                let camera = mapView.cameraThatFitsCoordinateBounds(sourceFeatures.overlayBounds, edgePadding: edgePadding)
                mapView.setCamera(camera, animated: true)
                
                let sourceOptions: [MGLShapeSourceOption: Any] = [.lineDistanceMetrics: true]
                var source: MGLShapeSource = .init(identifier: "")
                if let sourceExist = style.source(withIdentifier: "lineSourceIdentifier") as? MGLShapeSource {
                    source = sourceExist
                } else {
                    source = MGLShapeSource(identifier: "lineSourceIdentifier", shape: sourceFeatures, options: sourceOptions)
                    style.addSource(source)
                }
                
                let polylineLayer = MGLLineStyleLayer(identifier: "lineLayerIdentifier", source: source)
                polylineLayer.lineColor = NSExpression(forConstantValue: UIColor.red)
                polylineLayer.lineWidth = NSExpression(forConstantValue: 4)
                polylineLayer.lineDashPattern = NSExpression(forConstantValue: [5, 2])
                style.addLayer(polylineLayer)
            }else {
                sender.setTitle("Add", for: .normal)
                guard let style = mapView.style else {return}
                
                if let layer = style.layer(withIdentifier: "lineLayerIdentifier") as? MGLLineStyleLayer {
                    style.removeLayer(layer)
                }
            }
        default:
            break
        }
    }
}

extension PolylineViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        switch polylineSubOptionSelected {
        case .annotationPolyline:
            addAddPolylineButton()
        case .stylePolyline:
            let sourceFeatures = MGLPolylineFeature(coordinates: coordinates, count: UInt(coordinates.count))
            let edgePadding = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)
            let camera = mapView.cameraThatFitsCoordinateBounds(sourceFeatures.overlayBounds, edgePadding: edgePadding)
            mapView.setCamera(camera, animated: true)
            
            let sourceOptions: [MGLShapeSourceOption: Any] = [.lineDistanceMetrics: true]
            let source = MGLShapeSource(identifier: "lineSourceIdentifier", shape: sourceFeatures, options: sourceOptions)
            
            style.addSource(source)
            let polylineLayer = MGLLineStyleLayer(identifier: "lineLayerIdentifier", source: source)
            polylineLayer.lineColor = NSExpression(forConstantValue: UIColor.red)
            polylineLayer.lineWidth = NSExpression(forConstantValue: 8)
            style.addLayer(polylineLayer)
        case .polylineClick:
            let polyline = MGLPolyline(coordinates: coordinates, count: UInt(coordinates.count))
            mapView.addAnnotation(polyline)
            mapView.showAnnotations([polyline], animated: true)
        case .dashedPolyline:
            let sourceFeatures = MGLPolylineFeature(coordinates: coordinates, count: UInt(coordinates.count))
            let edgePadding = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)
            let camera = mapView.cameraThatFitsCoordinateBounds(sourceFeatures.overlayBounds, edgePadding: edgePadding)
            mapView.setCamera(camera, animated: true)
            
            let sourceOptions: [MGLShapeSourceOption: Any] = [.lineDistanceMetrics: true]
            let source = MGLShapeSource(identifier: "lineSourceIdentifier", shape: sourceFeatures, options: sourceOptions)
            
            style.addSource(source)
            let polylineLayer = MGLLineStyleLayer(identifier: "lineLayerIdentifier", source: source)
            polylineLayer.lineColor = NSExpression(forConstantValue: UIColor.red)
            polylineLayer.lineWidth = NSExpression(forConstantValue: 4)
            polylineLayer.lineDashPattern = NSExpression(forConstantValue: [5, 2])
            style.addLayer(polylineLayer)
        case .dottedPolyline:
            let MBRouteDotSpacingByZoomLevel: [Double: NSExpression] = [
                1: NSExpression(forConstantValue:1.0),
                2: NSExpression(forConstantValue:1.0),
                3: NSExpression(forConstantValue:1.0),
                4: NSExpression(forConstantValue:1.0),
                5: NSExpression(forConstantValue:1.0),
                6: NSExpression(forConstantValue:2.0),
                7: NSExpression(forConstantValue:3.0),
                8: NSExpression(forConstantValue:4.0),
                9: NSExpression(forConstantValue:5.0),
                10: NSExpression(forConstantValue:6.0),
                22: NSExpression(forConstantValue:30.0)
            ]
            
            let sourceFeatures = MGLPolylineFeature(coordinates: coordinates, count: UInt(coordinates.count))
            let edgePadding = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)
            let camera = mapView.cameraThatFitsCoordinateBounds(sourceFeatures.overlayBounds, edgePadding: edgePadding)
            mapView.setCamera(camera, animated: true)
            
            let sourceOptions: [MGLShapeSourceOption: Any] = [.lineDistanceMetrics: true]
            let source = MGLShapeSource(identifier: "lineSourceIdentifier", shape: sourceFeatures, options: sourceOptions)
            
            style.addSource(source)
            
            let shapeLayer = MGLSymbolStyleLayer(identifier: "shapeLayer", source: source)
            
            style.setImage(UIImage(named: "dotImage")!, forName: "dot-image")
            
            shapeLayer.minimumZoomLevel = 3.0
            shapeLayer.iconImageName = NSExpression(forConstantValue: "dot-image")
            
            shapeLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
            shapeLayer.symbolPlacement =  NSExpression(forConstantValue: NSValue(mglSymbolPlacement: .line))
            shapeLayer.symbolSpacing =  NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", MBRouteDotSpacingByZoomLevel)
            shapeLayer.iconScale = NSExpression(forConstantValue: 0.4)
            style.addLayer(shapeLayer)
        case .polylineWithDifferentColors:
            addAddPolylineButton()
        case .polylineBorder:
            let sourceFeatures = MGLPolylineFeature(coordinates: coordinates, count: UInt(coordinates.count))
            let edgePadding = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)
            let camera = mapView.cameraThatFitsCoordinateBounds(sourceFeatures.overlayBounds, edgePadding: edgePadding)
            mapView.setCamera(camera, animated: true)
            
            let sourceOptions: [MGLShapeSourceOption: Any] = [.lineDistanceMetrics: true]
            let source = MGLShapeSource(identifier: "lineSourceIdentifier", shape: sourceFeatures, options: sourceOptions)
            
            style.addSource(source)
            let polylineLayer = MGLLineStyleLayer(identifier: "lineLayerIdentifierBottom", source: source)
            polylineLayer.lineColor = NSExpression(forConstantValue: UIColor.blue)
            polylineLayer.lineWidth = NSExpression(forConstantValue: 8)
            
            let polylineLayerTop = MGLLineStyleLayer(identifier: "lineLayerIdentifierTop", source: source)
            polylineLayerTop.lineColor = NSExpression(forConstantValue: UIColor.yellow)
            polylineLayerTop.lineWidth = NSExpression(forConstantValue: 5)
            
            style.addLayer(polylineLayerTop)
            style.insertLayer(polylineLayer, below: polylineLayerTop)
        case .congestionRoutePolyline:
            let waypoints = [
                Waypoint(coordinate: CLLocationCoordinate2D(latitude: 28.551078, longitude: 77.268968), name: "Mappls"),
                Waypoint(coordinate: CLLocationCoordinate2D(latitude: 22.572645, longitude: 88.363892), name: "Moolchand")
            ]
            self.activityIndicator.startAnimating()
            let options: RouteOptions = RouteOptions(waypoints: waypoints, resourceIdentifier: .routeETA, profileIdentifier: .driving)
            options.includesAlternativeRoutes = true
            options.attributeOptions = [.congestionLevel]
            options.includesSteps = true
            APIManager.getRoute(options: options) { routes, waypoints in
                guard let routes = routes else {return}
                self.polylinePlugin = PolylineLayerPlugin(mapView: self.mapView)
                self.polylinePlugin!.showRoutes(routes: routes)
                self.setMapTapGesture()
                self.activityIndicator.stopAnimating()
            } failure: { error in
                print(error.localizedDescription)
                self.activityIndicator.stopAnimating()
            }
        case .polylineAnimatedLengthChange:
            let destinationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 22.572645, longitude: 88.363892)
            let initialCoordiante: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 28.551635, longitude: 77.268805)
            
            let routeOptions = RouteOptions(waypoints: [Waypoint(coordinate: initialCoordiante), Waypoint(coordinate: destinationCoordinate)], resourceIdentifier: .routeETA, profileIdentifier: .driving)
            routeOptions.includesSteps = true
            
            APIManager.getRoute(options: routeOptions) { routes, waypoints in
                guard let routes = routes, let route = routes.first else {return}
                self.route = route
                
                let feature = MGLPolylineFeature(coordinates: route.coordinates ?? [], count: route.coordinateCount)
                mapView.showAnnotations([feature], animated: true)
                
                let source = MGLShapeSource(identifier: "lineSourceIdentifier", shape: nil, options: nil)
                style.addSource(source)
                
                self.polylineSource = source
                
                let polylineLayer = MGLLineStyleLayer(identifier: "lineLayerIdentifier", source: source)
                polylineLayer.lineColor = NSExpression(forConstantValue: UIColor.red)
                polylineLayer.lineWidth = NSExpression(forConstantValue: 8)
                style.addLayer(polylineLayer)
                
                self.animationTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.animateLength), userInfo: nil, repeats: true)
            } failure: { error in
                print(error.localizedDescription)
            }
        case .polygon:
            addAddPolylineButton()
        case .circle:
            let centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(28.551635, 77.268805)
            let coordinates: [CLLocationCoordinate2D] = Utility.polygonCircleForCoordinate(coordinate: centerCoordinate, withMeterRadius: 100)
            
            let circle = MGLPolygon(coordinates: coordinates, count: UInt(coordinates.count))
            mapView.addAnnotation(circle)
            mapView.showAnnotations([circle], animated: true)
        case .interiorPolygon:
            let sourceFeatures = getSourceFeatures(coordinate:CLLocationCoordinate2DMake(28.550834, 77.268918), radius: 100)
            // Create source and add it to the map style.
            let source = MGLShapeSource(identifier: "interiorPolygonSourceIdentifier", shape: sourceFeatures, options: nil)
            style.addSource(source)
            
            let polygonLayer = MGLFillStyleLayer(identifier: "interiorPolygonLayerIdentifier", source: source)
            polygonLayer.fillColor = NSExpression(forConstantValue: UIColor.red)
            polygonLayer.fillOpacity = NSExpression(forConstantValue: 0.5)
            polygonLayer.fillOutlineColor = NSExpression(forConstantValue: UIColor.black)
            
            // Add style layers to the map view's style.
            style.addLayer(polygonLayer)
            
            if let shape = sourceFeatures.interiorPolygons?.first {
                let shapeCam = mapView.cameraThatFitsShape(shape, direction: CLLocationDirection(0), edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
                mapView.setCamera(shapeCam, animated: false)
            }
            addInteriorPolygonOnMap()
        case .geodesicPolyline:
            let startCoordinate = CLLocationCoordinate2D(latitude: 28.555278, longitude: 77.085725) // San Francisco
            let endCoordinate = CLLocationCoordinate2D(latitude: 19.089443, longitude: 72.865053) // Los Angeles
            
            let greateCircle = GreatCircle()
            let delhiCoordinate = CLLocationCoordinate2DMake(28.555278, 77.085725)
            let mumbaiCoordinate = CLLocationCoordinate2DMake(19.089443, 72.865053)
            let kolkataCoordinate = CLLocationCoordinate2DMake(22.650290, 88.446447)
            
            let delhiToMumbaiCoordinates = greateCircle.discretizePoints(fromCoordinate: delhiCoordinate, toCoordinate: mumbaiCoordinate)
            let delhiToKolkataCoordinates = greateCircle.discretizePoints(fromCoordinate: delhiCoordinate, toCoordinate: kolkataCoordinate)
            
            let delhiToMumbaiPolyline = MGLPolyline(coordinates: delhiToMumbaiCoordinates, count: UInt(delhiToMumbaiCoordinates.count))
            let delhiToKolkataPolyline = MGLPolyline(coordinates: delhiToKolkataCoordinates, count: UInt(delhiToKolkataCoordinates.count))
            
            mapView.addAnnotations([delhiToMumbaiPolyline, delhiToKolkataPolyline])
            
            let allCoordinates = delhiToMumbaiCoordinates + delhiToKolkataCoordinates
            let polygon = MGLPolygon(coordinates: allCoordinates, count: UInt(allCoordinates.count))
            
            let shapeCam = mapView.cameraThatFitsShape(polygon, direction: CLLocationDirection(0), edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
            mapView.setCamera(shapeCam, animated: false)
        case .semicirclePolyline:
            addAddPolylineButton()
        case .snakeMotionPolyline:
            break
        default:
            break
        }
    }
    
    func combine(_ coordinates: [CLLocationCoordinate2D], with congestions: [CongestionLevel]) -> [CongestionSegment] {
        var segments: [CongestionSegment] = []
        segments.reserveCapacity(congestions.count)
        for (index, congestion) in congestions.enumerated() {
            
            let congestionSegment: ([CLLocationCoordinate2D], CongestionLevel) = ([coordinates[index], coordinates[index + 1]], congestion)
            let coordinates = congestionSegment.0
            let congestionLevel = congestionSegment.1
            
            if segments.last?.1 == congestionLevel {
                segments[segments.count - 1].0 += coordinates
            } else {
                segments.append(congestionSegment)
            }
        }
        return segments
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        if polylineSubOptionSelected == .polylineClick {
            let alertController = UIAlertController(title: "Polyline Clicked!", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            present(alertController, animated: true)
        } else if polylineSubOptionSelected == .congestionRoutePolyline {
            
        }
    }
}

extension PolylineViewController: NavigationProtocol {
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension PolylineViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
            self.activityIndicator.color = theme.backgroundSecondary
        }
    }
}
