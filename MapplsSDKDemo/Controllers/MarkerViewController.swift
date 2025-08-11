//
//  MarkerViewController.swift
//  MapplsSDKDemo
//
//  Created by rento on 16/01/25.
//

import UIKit
import MapplsMap

struct CoordinateMode {
    let coordinates: [CLLocationCoordinate2D]
    let type: String
    let imageName: String

    let iconScale: Double
}

class MarkerViewController: UIViewController {
    var markerSubOptionSelected: SubOptionsEnum!
    var navBarView: NavigationBarView!
    var mapView: MapplsMapView!
    var mapCenterBtn: UIButton!
    var latLonToast: LatLongDisplayToast?
    let coordinates = [
        CLLocationCoordinate2DMake(28.551635, 77.268805),
        CLLocationCoordinate2DMake(28.551041, 77.267979),
        CLLocationCoordinate2DMake(28.552115, 77.265833),
        CLLocationCoordinate2DMake(28.559786, 77.238859),
        CLLocationCoordinate2DMake(28.561535, 77.233345),
        CLLocationCoordinate2DMake(28.562469, 77.235072),
        CLLocationCoordinate2DMake(28.435931, 77.304689),
        CLLocationCoordinate2DMake(28.436214, 77.304936),
        CLLocationCoordinate2DMake(28.438827, 77.308337),
        CLLocationCoordinate2DMake(28.489028, 77.091252),
        CLLocationCoordinate2DMake(28.486831, 77.094492),
        CLLocationCoordinate2DMake(28.486491, 77.094374),
        CLLocationCoordinate2DMake(28.491510, 77.082149),
        CLLocationCoordinate2DMake(28.474800, 77.065233),
        CLLocationCoordinate2DMake(28.471245, 77.072722),
        CLLocationCoordinate2DMake(28.458440, 77.073179)
    ]
    var displayLink: CADisplayLink? {
        didSet { oldValue?.invalidate() }
    }
    var route: Route?
    var animationAnnotation: MGLPointFeature?
    var animationAnnotationIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
    
    func setUpUI() {
        navBarView = NavigationBarView(title: markerSubOptionSelected.rawValue)
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
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(mapView, belowSubview: navBarView)
        
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
        if let location = CLLocationManager().location {
            mapView.setCenter(location.coordinate, zoomLevel: 18, animated: true)
        }
    }
    
    func addTapGestureOnMap() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.didClickOnMapView(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func didClickOnMapView(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            var point = sender.location(in: mapView)
            switch markerSubOptionSelected {
            case .tapGestureOnLayer:
                point.x = point.x-25
                point.y = point.y-25
                
                let rect = CGRect(origin: point, size: CGSize(width: 50, height: 50))
                
                let visibleFeature = mapView.visibleFeatures(in: rect, styleLayerIdentifiers: ["symbolStyleIdentifier"])
                mapView.annotations?.forEach({ annotation in
                    if annotation.title == "hiddenAnnotation" {
                        mapView.removeAnnotation(annotation)
                    }
                })
                
                if visibleFeature.count > 0 {
                    let featureCoordinate: CLLocationCoordinate2D = visibleFeature.first!.coordinate
                    let annotation: MGLPointAnnotation = MGLPointAnnotation()
                    annotation.coordinate = featureCoordinate
                    mapView.addAnnotation(annotation)
                    annotation.title = "hiddenAnnotation"
                    mapView.selectAnnotation(annotation, animated: true, completionHandler: nil)
                }
            case .clustering:
                guard let source = mapView.style?.source(withIdentifier: "sourceIdentifier") as? MGLShapeSource, let cluster = firstCluster(with: sender) else {return}
                
                let zoom = source.zoomLevel(forExpanding: cluster)
                if zoom > 0 {
                    mapView.setCenter(cluster.coordinate, zoomLevel: zoom, animated: true)
                }
            default:
                break
            }
        default:
            break
        }
    }
    
    func firstCluster(with gestureRecognizer: UIGestureRecognizer) -> MGLPointFeatureCluster? {
        let point = gestureRecognizer.location(in: gestureRecognizer.view)
        let width = 50
        let rect = CGRect(x: Int(point.x) - width / 2, y: Int(point.y) - width / 2, width: width, height: width)
        
        let features = mapView.visibleFeatures(in: rect, styleLayerIdentifiers: ["clusterLayerIdentifier"])
        let clusters = features.compactMap { $0 as? MGLPointFeatureCluster }
        
        return clusters.first
    }
    
    @objc private func updateFromDisplayLink(displayLink: CADisplayLink) {
        guard let route = route, let coordinates = route.coordinates, coordinates.count > 0 else {
            displayLink.invalidate()
            self.displayLink = nil
            return
        }
        
        if animationAnnotationIndex > coordinates.count {
            displayLink.invalidate()
            self.displayLink = nil
            return
        }
        
        animationAnnotationIndex += 10
        
        if animationAnnotationIndex > coordinates.count {
            animationAnnotationIndex = coordinates.count-1
        }
        
        let start = coordinates[animationAnnotationIndex]
        let end = coordinates[animationAnnotationIndex-1]
        
        let progress = CGFloat(displayLink.timestamp.truncatingRemainder(dividingBy: 1))
        let newLatitude = start.latitude + (end.latitude - start.latitude) * Double(progress)
        let newLongitude = start.longitude + (end.longitude - start.longitude) * Double(progress)
        animationAnnotation?.coordinate = CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
        if let style = mapView.style {
            if let layer = style.layer(withIdentifier: "symbolLayerIdentifier") {
                style.removeLayer(layer)
            }
            if let source = style.source(withIdentifier: "symbolLayerIdentifier") {
                style.removeSource(source)
            }
            let feature = MGLPointFeature()
            feature.coordinate = .init(latitude: newLatitude, longitude: newLongitude)
            let source = MGLShapeSource(identifier: "symbolLayerIdentifier", features: [feature])
            let layer = MGLSymbolStyleLayer(identifier: "symbolLayerIdentifier", source: source)
            layer.iconAnchor = NSExpression(forConstantValue: NSValue(mglIconAnchor: .bottom))
            layer.iconImageName = NSExpression(forConstantValue: "icon")
            style.addSource(source)
            style.addLayer(layer)
        }
    }
    
    private func animatePositionForAnimatedMarker(on route: Route) {
        displayLink = CADisplayLink(target: self, selector: #selector(self.updateFromDisplayLink(displayLink:)))
        displayLink?.add(to: .current, forMode: .common)
    }
    
    func addMapplsPinSearchView() {
        let searchView = CommonSearchBarView()
        searchView.setSearchText(placeholder: "Mappls Pin (e.g., MMI000, 2SHATN)")
        searchView.delegate = self
        searchView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(searchView, belowSubview: navBarView)
        
        NSLayoutConstraint.activate([
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchView.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func addLatLongDisplayViewToMap(isHidden: Bool = true) {
        latLonToast = LatLongDisplayToast()
        latLonToast!.setLatLong(lat: 0.0, long: 0.0, altitude: 0.0, isOnMove: false)
        latLonToast!.isHidden = isHidden
        latLonToast!.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(latLonToast!)
        
        NSLayoutConstraint.activate([
            latLonToast!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            latLonToast!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            latLonToast!.heightAnchor.constraint(equalToConstant: 60),
            latLonToast!.bottomAnchor.constraint(equalTo: mapCenterBtn.topAnchor, constant: -20)
        ])
    }
    
    deinit {
        displayLink?.invalidate()
        print("deinit called")
    }
}

extension MarkerViewController: CommonSearchBarDelegate {
    func searchDidChange(text: String) async {
        
    }
    
    func didPressDone(text: String) async {
        let annotation: MGLPointAnnotation = MGLPointAnnotation()
        annotation.mapplsPin = text
        mapView.removeAnnotations(mapView.annotations ?? [])
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
    }
}

extension MarkerViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        switch markerSubOptionSelected {
        case .addAnnotationMarker, .customAnnotationView, .customAnnotationImage, .calloutOnAnnotationClick, .customCalloutOnAnnotationClick, .actionOnAnnotationCalloutClick, .draggableAnnoatation:
            let annotation: MGLPointAnnotation = MGLPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: 28.550834, longitude: 77.268918)
            mapView.addAnnotation(annotation)
            mapView.setCenter(annotation.coordinate, zoomLevel: 18, animated: true)
            if markerSubOptionSelected == .calloutOnAnnotationClick || markerSubOptionSelected == .customCalloutOnAnnotationClick || markerSubOptionSelected == .actionOnAnnotationCalloutClick {
                annotation.title = "lat- 77.268918, lon- 77.268918"
            }
            if markerSubOptionSelected == .draggableAnnoatation {
                addLatLongDisplayViewToMap()
            }
        case .addCustomMarkerUsingMapplsPin:
            addMapplsPinSearchView()
        case .addAnnotationMarkerUsingMapplsPin:
            addMapplsPinSearchView()
        case .annotationUsingStyleLayer, .tapGestureOnLayer:
            if markerSubOptionSelected == .tapGestureOnLayer {
                addTapGestureOnMap()
            }
            let icon: UIImage = UIImage(named: "dest-pin")!
            style.setImage(icon, forName: "icon")
            
            let feature: MGLPointFeature = MGLPointFeature()
            feature.coordinate = CLLocationCoordinate2D(latitude: 28.551635, longitude: 77.268805)
            let source: MGLShapeSource = MGLShapeSource(identifier: "shapeSourceFeature", features: [feature])
            style.addSource(source)
            
            let layer: MGLSymbolStyleLayer = MGLSymbolStyleLayer(identifier: "symbolStyleIdentifier", source: source)
            layer.iconImageName = NSExpression(forConstantValue: "icon")
            
            style.addLayer(layer)
            
            mapView.setCenter(CLLocationCoordinate2D(latitude: 28.551635, longitude: 77.268805), zoomLevel: 18, animated: true)
        case .clustering:
            let icon: UIImage = UIImage(named: "dest-pin")!
            
            var features: [MGLPointFeature] = []
            coordinates.forEach { coordinate in
                let feature = MGLPointFeature()
                feature.coordinate = coordinate
                features.append(feature)
            }
            let shape = MGLShapeCollectionFeature(shapes: features)
            
            let source = MGLShapeSource(identifier: "sourceIdentifier", shape: shape, options: [.clustered: true, .clusterRadius: icon.size.width])
            style.addSource(source)
            style.setImage(icon, forName: "icon")
            
            let layer = MGLSymbolStyleLayer(identifier: "unclusterLayerIdentifier", source: source)
            layer.iconImageName = NSExpression(forConstantValue: "icon")
            layer.predicate = NSPredicate(format: "cluster != YES")
            layer.iconAllowsOverlap = NSExpression(forConstantValue: true)
            style.addLayer(layer)
            
            let stops = [
                20: UIColor.lightGray,
                50: UIColor.orange,
                100: UIColor.red,
                200: UIColor.purple
            ]
            
            let circlesLayer = MGLCircleStyleLayer(identifier: "clusterLayerIdentifier", source: source)
            circlesLayer.circleRadius = NSExpression(forConstantValue: NSNumber(value: Double(icon.size.width) / 2))
            circlesLayer.circleOpacity = NSExpression(forConstantValue: 0.75)
            circlesLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.white.withAlphaComponent(0.75))
            circlesLayer.circleStrokeWidth = NSExpression(forConstantValue: 2)
            circlesLayer.circleColor = NSExpression(format: "mgl_step:from:stops:(point_count, %@, %@)", UIColor.lightGray, stops)
            circlesLayer.predicate = NSPredicate(format: "cluster == YES")
            style.addLayer(circlesLayer)
            
            let numbersLayer = MGLSymbolStyleLayer(identifier: "clusterLayerCountIdentifier", source: source)
            numbersLayer.textColor = NSExpression(forConstantValue: UIColor.black)
            numbersLayer.textFontSize = NSExpression(forConstantValue: NSNumber(value: Double(icon.size.width) / 2))
            numbersLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
            numbersLayer.text = NSExpression(format: "CAST(point_count, 'NSString')")
            numbersLayer.textFontNames = NSExpression(forConstantValue: ["Open Sans Bold"])
            
            numbersLayer.predicate = NSPredicate(format: "cluster == YES")
            style.addLayer(numbersLayer)
            
            let shapeCam = mapView.cameraThatFitsShape(shape, direction: CLLocationDirection(0), edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
            mapView.setCamera(shapeCam, animated: false)
            
            addTapGestureOnMap()
        case .multipleAnnotationsUsingStyleLayer, .annotationOverlapPriority:
            let icon: UIImage = UIImage(named: "viapoint-image")!
            
            var features: [MGLPointFeature] = []
            for (index, coordinate) in coordinates.enumerated() {
                let feature = MGLPointFeature()
                feature.coordinate = coordinate
                if markerSubOptionSelected == .annotationOverlapPriority {
                    feature.attributes = [
                        "symbol-sort-key": index,
                        "title": "\(index)"
                    ]
                }
                features.append(feature)
            }
            
            let shape = MGLShapeCollectionFeature(shapes: features)
            
            let source = MGLShapeSource(identifier: "sourceIdentifier", shape: shape)
            style.addSource(source)
            style.setImage(icon, forName: "icon")
            
            let layer = MGLSymbolStyleLayer(identifier: "symbolLayerIdentifier", source: source)
            layer.iconImageName = NSExpression(forConstantValue: "icon")
            layer.iconAllowsOverlap = NSExpression(forConstantValue: true)
            layer.textAllowsOverlap = NSExpression(forConstantValue: true)
            
            if markerSubOptionSelected == .annotationOverlapPriority {
                layer.symbolZOrder = NSExpression(forConstantValue: NSValue(mglSymbolZOrder: .auto))
                layer.text = NSExpression(forKeyPath: "title")
                layer.textOffset = NSExpression(forConstantValue: CGVector(dx: 0, dy: -0.5))
            }
            
            style.addLayer(layer)
            
            mapView.showAnnotations(features, animated: true)
        case .titleInAnnotation, .annotationAnchorAndOffset:
            let icon: UIImage = UIImage(named: "dest-pin")!
            style.setImage(icon, forName: "icon")
            
            let feature: MGLPointFeature = MGLPointFeature()
            feature.coordinate = CLLocationCoordinate2D(latitude: 28.551635, longitude: 77.268805)
            
            let source: MGLShapeSource = MGLShapeSource(identifier: "shapeSourceFeature", features: [feature])
            style.addSource(source)
            
            let layer: MGLSymbolStyleLayer = MGLSymbolStyleLayer(identifier: "symbolStyleIdentifier", source: source)
            layer.iconImageName = NSExpression(forConstantValue: "icon")
            
            if markerSubOptionSelected == .annotationAnchorAndOffset {
                layer.iconOffset = NSExpression(forConstantValue: CGVector(dx: icon.size.width, dy: icon.size.height/2))
            }else {
                layer.text = NSExpression(forConstantValue: "Title Annotation")
                layer.textOffset = NSExpression(forConstantValue: CGVector(dx: 0, dy: 1.5))
            }
            
            style.addLayer(layer)
            
            mapView.setCenter(CLLocationCoordinate2D(latitude: 28.551635, longitude: 77.268805), zoomLevel: 18, animated: true)
        case .animatedMarker:
            let destinationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 22.572645, longitude: 88.363892)
            let initialCoordiante: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 28.551635, longitude: 77.268805)
            let routeOptions = RouteOptions(waypoints: [Waypoint(coordinate: initialCoordiante), Waypoint(coordinate: destinationCoordinate)], resourceIdentifier: .routeETA, profileIdentifier: .driving)
            routeOptions.includesSteps = true
            
            APIManager.getRoute(options: routeOptions) { routes, waypoints in
                guard let routes = routes, let route: Route = routes.first else {return}
                let polyline = MGLPolylineFeature(coordinates: route.coordinates ?? [], count: route.coordinateCount)
                
                let marker = MGLPointFeature()
                marker.coordinate = initialCoordiante
                
                let lineSource = MGLShapeSource(identifier: "lineSource", features: [polyline])
                if let source = style.source(withIdentifier: "lineSource") {
                    style.removeSource(source)
                }
                style.addSource(lineSource)
                
                style.setImage(UIImage(named: "marker1")!, forName: "icon")
                
                let markerSource = MGLShapeSource(identifier: "markerAnimateSource", features: [marker])
                if let source = style.source(withIdentifier: "markerAnimateSource") {
                    style.removeSource(source)
                }
                
                style.addSource(markerSource)
                
                let polylineLayer = MGLLineStyleLayer(identifier: "lineLayerIdentifier", source: lineSource)
                polylineLayer.lineColor = NSExpression(forConstantValue: UIColor.red)
                polylineLayer.lineWidth = NSExpression(forConstantValue: 8)
                
                let symbolLayer = MGLSymbolStyleLayer(identifier: "symbolLayerIdentifier", source: markerSource)
                symbolLayer.iconAnchor = NSExpression(forConstantValue: NSValue(mglIconAnchor: .bottom))
                symbolLayer.iconImageName = NSExpression(forConstantValue: "icon")
                
                if let layer = style.layer(withIdentifier: "symbolLayerIdentifier") {
                    style.removeLayer(layer)
                }
 
                if let layer = style.layer(withIdentifier: "lineLayerIdentifier") {
                    style.removeLayer(layer)
                }
                
                style.addLayer(polylineLayer)
                style.addLayer(symbolLayer)
                
                mapView.showAnnotations([polyline], animated: true)
                
                self.route = route
                self.animationAnnotation = marker
                
                self.animatePositionForAnimatedMarker(on: route)
            } failure: { error in
                print(error.localizedDescription)
            }
        case .advancedClustering:
            drawAdvancedClusteringLayerOnMap(style: style)
        case .removeMarker:
            let annotation = MGLPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: 28.551635, longitude: 77.268805)
            mapView.addAnnotation(annotation)
            mapView.setCenter(CLLocationCoordinate2D(latitude: 28.551635, longitude: 77.268805), zoomLevel: 18, animated: true)
        case .iconScale:
            let IconScaleZoomLevel: [Int: NSExpression] = [
                5: NSExpression(forConstantValue: 1),
                6: NSExpression(forConstantValue: 1.1),
                7: NSExpression(forConstantValue: 1.5),
                8: NSExpression(forConstantValue: 2),
                9: NSExpression(forConstantValue: 2.2),
                10: NSExpression(forConstantValue: 2.7),
                11: NSExpression(forConstantValue: 3)
            ]
            var pointFeatures = [MGLPointFeature]()
            
            let coordintes = [
                CLLocationCoordinate2DMake(28.99, 77.89),
                CLLocationCoordinate2DMake(28.78, 77.98),
                CLLocationCoordinate2DMake(28.56, 77.2088),
                CLLocationCoordinate2DMake(28.7041, 77.1025)
            ]
            for coordinte in coordintes {
                let pointFeature = MGLPointFeature()
                pointFeature.coordinate = coordinte
                pointFeatures.append(pointFeature)
            }
            
            style.setImage(UIImage(named: "destination-icon")!, forName: "my-image")
            
            let shape = MGLShapeCollectionFeature(shapes: pointFeatures)
            
            let source = MGLShapeSource(identifier: "sourceIdentifier", shape: shape, options: [:])
            style.addSource(source)
            let styleLayer = MGLSymbolStyleLayer(identifier: "layerIdentifier", source: source)
            styleLayer.iconImageName = NSExpression(forConstantValue: "my-image")
            styleLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
            styleLayer.iconScale = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", IconScaleZoomLevel)
            style.addLayer(styleLayer)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                let camera = self.mapView.cameraThatFitsShape(shape, direction: 0, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
                self.mapView.fly(to: camera, withDuration: 10)
            })
        case .categoriesMarker:
            let categoriesMarkerSourceIdentifier = "categoriesMarkerSourceIdentifier"
            let categoriesMarkerLayerIdentifier = "categoriesMarkerLayerIdentifier"
            var pointCollection = [MGLPointFeature]()
            var coordinateModes = [CoordinateMode]()
            
            if let layer = style.layer(withIdentifier: categoriesMarkerLayerIdentifier) {
                style.removeLayer(layer)
            }
            if let source = style.source(withIdentifier: categoriesMarkerSourceIdentifier) {
                style.removeSource(source)
            }
            
            coordinateModes.append(CoordinateMode(coordinates: [
                CLLocationCoordinate2D(latitude: 28.551066333120303, longitude: 77.26894112705402),
                CLLocationCoordinate2D(latitude: 28.551032386058182, longitude: 77.26857784675235),
                CLLocationCoordinate2D(latitude: 28.55100251263445, longitude: 77.2681589150002),
                CLLocationCoordinate2D(latitude: 28.5509864404147, longitude: 77.26788643376327),
                CLLocationCoordinate2D(latitude: 28.550966655081883, longitude: 77.2676358488731)
            ], type: "type1", imageName: "marker1", iconScale: 0.5))
            
            coordinateModes.append(CoordinateMode(coordinates: [
                CLLocationCoordinate2D(latitude: 28.55124520780553, longitude: 77.26962574301831),
                CLLocationCoordinate2D(latitude: 28.551022885593035, longitude: 77.26968158978625),
                CLLocationCoordinate2D(latitude: 28.5507148687776, longitude: 77.26976529749032)
            ], type: "type2", imageName: "marker3", iconScale: 0.3))
            
            for coordinateMode in coordinateModes {
                if let style = mapView.style,
                   style.image(forName: coordinateMode.imageName) == nil,
                   let image = UIImage(named: coordinateMode.imageName) {
                    style.setImage(image, forName: coordinateMode.imageName)
                }
                
                for coordinate in coordinateMode.coordinates {
                    if CLLocationCoordinate2DIsValid(coordinate) {
                        let pointFeature = MGLPointFeature()
                        pointFeature.coordinate = coordinate
                        pointFeature.title = coordinateMode.type
                        pointFeature.attributes = [
                            "type": coordinateMode.type,
                            "icon-image": coordinateMode.imageName,
                            "icon-rotate": 0,
                            "icon-scale": coordinateMode.iconScale,
                        ]
                        pointCollection.append(pointFeature)
                    }
                }
                
                let pointCollectionShape = MGLShapeCollectionFeature(shapes: pointCollection)
                
                if let source = style.source(withIdentifier: categoriesMarkerSourceIdentifier) as? MGLShapeSource {
                    source.shape = pointCollectionShape
                } else {
                    let movingMarkerSource = MGLShapeSource(identifier: categoriesMarkerSourceIdentifier, shape: pointCollectionShape, options: nil)
                    style.addSource(movingMarkerSource)
                    
                    let symbolLayer = MGLSymbolStyleLayer(identifier: categoriesMarkerLayerIdentifier, source: movingMarkerSource)
                    symbolLayer.sourceLayerIdentifier = "MovingMarkerLayer"
                    symbolLayer.iconScale = NSExpression(forKeyPath: "icon-scale")
                    symbolLayer.iconImageName = NSExpression(forKeyPath: "icon-image")
                    symbolLayer.iconRotation = NSExpression(forKeyPath: "icon-rotate")
                    symbolLayer.iconAnchor = NSExpression(forConstantValue: NSValue(mglIconAnchor: .bottom))
                    symbolLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
                    symbolLayer.iconRotationAlignment = NSExpression(forConstantValue: NSValue.init(mglIconRotationAlignment: .map))
                    style.addLayer(symbolLayer)
                }
                mapView.setCenter(CLLocationCoordinate2D(latitude: 28.551066333120303, longitude: 77.26894112705402), zoomLevel: 16, animated: true)
            }
        case .multipleAnnotationMarkerWithBounds:
            var annotations = [MGLPointAnnotation]()
            
            let coordinates = [
                CLLocationCoordinate2D(latitude: 28.550834, longitude: 77.268918),
                CLLocationCoordinate2D(latitude: 28.551059, longitude: 77.268890),
                CLLocationCoordinate2D(latitude: 28.550938, longitude: 77.267641),
                CLLocationCoordinate2D(latitude: 28.551764, longitude: 77.267575),
                CLLocationCoordinate2D(latitude: 28.552068, longitude: 77.267599),
                CLLocationCoordinate2D(latitude: 28.553836, longitude: 77.267450),
                ]
            for coordinate in coordinates {
                let annotation = MGLPointAnnotation()
                annotation.coordinate = coordinate
                annotations.append(annotation)
            }
            self.mapView.addAnnotations(annotations)
            self.mapView.showAnnotations(annotations, animated: true)
        case .multipleLayerMarkerWithBounds:
            var annotations = [MGLPointFeature]()
            
            let coordinates = [
                CLLocationCoordinate2D(latitude: 28.550834, longitude: 77.268918),
                CLLocationCoordinate2D(latitude: 28.551059, longitude: 77.268890),
                CLLocationCoordinate2D(latitude: 28.550938, longitude: 77.267641),
                CLLocationCoordinate2D(latitude: 28.551764, longitude: 77.267575),
                CLLocationCoordinate2D(latitude: 28.552068, longitude: 77.267599),
                CLLocationCoordinate2D(latitude: 28.553836, longitude: 77.267450),
                ]
            style.setImage(UIImage(named: "marker1")!, forName: "marker1")
            for coordinate in coordinates {
                let annotation = MGLPointFeature()
                annotation.coordinate = coordinate
                annotations.append(annotation)
            }
            let source = MGLShapeSource(identifier: "shapeSourceForBounds", features: annotations)
            style.addSource(source)
            let layer = MGLSymbolStyleLayer(identifier: "layerForBounds", source: source)
            layer.iconImageName = NSExpression(forConstantValue: "marker1")
            
            style.addLayer(layer)
            self.mapView.showAnnotations(annotations, animated: true)
        default:
            break
        }
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        if markerSubOptionSelected == .removeMarker {
            mapView.removeAnnotation(annotation)
        }
    }
    
    func drawAdvancedClusteringLayerOnMap(style: MGLStyle) {
        // Array of points
        let coordinates = [
            CLLocationCoordinate2DMake(28.551635, 77.268805),
            CLLocationCoordinate2DMake(28.551041, 77.267979),
            CLLocationCoordinate2DMake(28.552115, 77.265833),
            CLLocationCoordinate2DMake(28.559786, 77.238859),
            CLLocationCoordinate2DMake(28.561535, 77.233345),
            CLLocationCoordinate2DMake(28.562469, 77.235072),
            CLLocationCoordinate2DMake(28.435931, 77.304689),
            CLLocationCoordinate2DMake(28.436214, 77.304936),
            CLLocationCoordinate2DMake(28.438827, 77.308337),
            CLLocationCoordinate2DMake(28.489028, 77.091252),
            CLLocationCoordinate2DMake(28.486831, 77.094492),
            CLLocationCoordinate2DMake(28.486491, 77.094374),
            CLLocationCoordinate2DMake(28.491510, 77.082149),
            CLLocationCoordinate2DMake(28.474800, 77.065233),
            CLLocationCoordinate2DMake(28.471245, 77.072722),
            CLLocationCoordinate2DMake(28.458440, 77.073179)
        ]
        
        var pointFeatures: [MGLPointFeature] = []
        coordinates.forEach { coordinate in
            let feature: MGLPointFeature = MGLPointFeature()
            feature.coordinate = coordinate
            pointFeatures.append(feature)
        }
        
        // Setting different 'imageName', 'name' attributes of points to use dynamically in map layers.
        for (index, pointFeature) in pointFeatures.enumerated() {
            pointFeature.attributes = [
                "name": "index - \(index)",
                "imageName": index % 2 == 0 ? "yellowBubble" : "brownBubble"
            ]
        }
        
        // Set/Register all required images in style by checking if they are not registered.
        let redBubbleImage = UIImage(named: "redBubbleMarker")!
        let yellowBubbleImage = UIImage(named: "yellowBubbleMarker")!
        let brownBubbleImage = UIImage(named: "brownBubbleMarker")!
        
        if style.image(forName: "redBubble") == nil {
            style.setImage(redBubbleImage, forName: "redBubble")
        }
        if style.image(forName: "yellowBubble") == nil {
            style.setImage(yellowBubbleImage, forName: "yellowBubble")
        }
        if style.image(forName: "brownBubble") == nil {
            style.setImage(brownBubbleImage, forName: "brownBubble")
        }
        
        
        // Create marker source
        let shape = MGLShapeCollectionFeature(shapes: pointFeatures)
        
        let source = MGLShapeSource(identifier: "sourceIdentifier", shape: shape, options: [.clustered: true, .clusterRadius: redBubbleImage.size.width])
        style.addSource(source)
        
        // Show unclustered features as icons. The `cluster` attribute is built into clustering-enabled
        // source features.
        // Using property 'imageName' from attributes of feature to set icon dynamically
        let ports = MGLSymbolStyleLayer(identifier: "unclusterLayerIdentifier", source: source)
        ports.iconImageName = NSExpression(forKeyPath: "imageName")
        ports.iconAllowsOverlap = NSExpression(forConstantValue: true)
        ports.iconAnchor = NSExpression(forConstantValue: NSValue(mglIconAnchor: .bottom))
        ports.textColor = NSExpression(forConstantValue: UIColor.white)
        ports.textFontSize = NSExpression(forConstantValue: 8)
        ports.text = NSExpression(forKeyPath: "name")
        ports.textOffset = NSExpression(forConstantValue: CGVector(dx: 0, dy: -1.35))
        ports.textFontNames = NSExpression(forConstantValue: ["Open Sans Bold"])
        ports.predicate = NSPredicate(format: "cluster != YES")
        style.addLayer(ports)
        
        // Show clustered features as circles. The `point_count` attribute is built into
        // clustering-enabled source features.
        // Static icon 'redBubble' is used here.
        let clusterLayer = MGLSymbolStyleLayer(identifier: "clusterLayerIdentifier", source: source)
        clusterLayer.iconImageName = NSExpression(forConstantValue: "redBubble")
        clusterLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        clusterLayer.iconAnchor = NSExpression(forConstantValue: NSValue(mglIconAnchor: .bottom))
        
        clusterLayer.textColor = NSExpression(forConstantValue: UIColor.white)
        clusterLayer.textFontSize = NSExpression(forConstantValue: 8)
        clusterLayer.text = NSExpression(format: "mgl_join({CAST(point_count, 'NSString'), ' People'})")
        clusterLayer.textOffset = NSExpression(forConstantValue: CGVector(dx: 0, dy: -1.35))
        clusterLayer.textFontNames = NSExpression(forConstantValue: ["Open Sans Bold"])
        clusterLayer.predicate = NSPredicate(format: "cluster == YES")
        style.addLayer(clusterLayer)
        
        let shapeCam = mapView.cameraThatFitsShape(shape, direction: CLLocationDirection(0), edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        mapView.setCamera(shapeCam, animated: false)
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if !([SubOptionsEnum.clustering, SubOptionsEnum.addAnnotationMarker, SubOptionsEnum.addAnnotationMarkerUsingMapplsPin].contains(markerSubOptionSelected)) {
            let annotationImage: MGLAnnotationImage = MGLAnnotationImage(image: UIImage(data: (UIImage(named: "map-annotation-pin")?.pngData())!, scale: 10)!, reuseIdentifier: "customAnnotationImage")
            return annotationImage
        }
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        switch markerSubOptionSelected {
        case .customAnnotationView:
            return CustomAnnotationView(reuseIdentifier: "customAnnotationView")
        case .draggableAnnoatation:
            let annotationV = DraggableAnnotationView(reuseIdentifier: "draggableAnnotationView")
            annotationV.delegate = self
            return annotationV
        case .tapGestureOnLayer:
            let view = MGLAnnotationView()
            view.centerOffset = .init(dx: 0, dy: -30)
            return view
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        switch markerSubOptionSelected {
        case .customCalloutOnAnnotationClick, .tapGestureOnLayer:
            let customCallout = CustomCalloutView(representedObject: annotation)
            customCallout.minusButton.addTarget(self, action: #selector(self.mapZoomOut), for: .touchUpInside)
            customCallout.plusButton.addTarget(self, action: #selector(self.mapZoomIn), for: .touchUpInside)
            return customCallout
        default:
            return nil
        }
    }
    
    @objc func mapZoomIn(_ sender: UIButton) {
        mapView.setZoomLevel(min(mapView.zoomLevel + 2, 22), animated: true)
    }
    
    @objc func mapZoomOut(_ sender: UIButton) {
        mapView.setZoomLevel(max(mapView.zoomLevel - 2, 0), animated: true)
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        if markerSubOptionSelected == .actionOnAnnotationCalloutClick {
            let alertController = UIAlertController(title: "You clicked callout at:", message: "lat- \(annotation.coordinate.latitude), lon- \(annotation.coordinate.longitude)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            present(alertController, animated: true)
        }
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        switch markerSubOptionSelected {
        case .calloutOnAnnotationClick, .actionOnAnnotationCalloutClick, .customCalloutOnAnnotationClick, .tapGestureOnLayer:
            return true
        default:
            return false
        }
    }
}

extension MarkerViewController: DraggableAnnotationDelegate {
    func draggingDidEnd<T: MGLAnnotationView>(annotation: T) async {
        guard let coordinate = annotation.annotation?.coordinate else {return}
        latLonToast?.setLatLong(lat: coordinate.latitude, long: coordinate.longitude, altitude: 0, isOnMove: false)
        latLonToast?.appear()
    }
}

extension MarkerViewController: NavigationProtocol {
    func navigateBack() {
        navigationController?.popViewController(animated: true)
        if markerSubOptionSelected == .animatedMarker {
            displayLink?.invalidate()
        }
    }
}

extension MarkerViewController: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.view.backgroundColor = theme.backgroundPrimary
        }
    }
}

