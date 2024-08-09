//
//  RouteTrafficPolylineSample.swift
//  MapplsSDKDemo
//
//  Created by Atul Sharan on 09/08/24.
//  Copyright © 2024 MMI. All rights reserved.
//

import UIKit
import Foundation
import MapplsMap
import MapplsAPIKit

public class RouteTrafficPolylineSample: UIViewController {
    
    private var mapView: MapplsMapView!
    private var polylinePluginObj: PolylineLayerPlugin?
    private var routes: [Route]?
    
    public override func loadView() {
        super.loadView()
        setUpMapView()
        applyConstraint()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUpMapView() {
        mapView = MapplsMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        view.addSubview(mapView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnMap))
        self.mapView.addGestureRecognizer(tap)
    }
    
    func applyConstraint() {
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
    func displayRoutePolyline() {
        let origin = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090), name: "Source")
        let waypoint1 = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 23.0225, longitude: 72.5714), name: "Waypoint 1")
        let waypoint2 = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 18.5204, longitude: 73.8567), name: "Waypoint 2")
        let destination = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 19.0760, longitude: 72.8777), name: "Destiantion")
        origin.allowsArrivingOnOppositeSide = false
        destination.allowsArrivingOnOppositeSide = false
        
        let options = RouteOptions(waypoints: [origin, waypoint1, waypoint2,destination])
        options.routeShapeResolution = .full
        options.includesAlternativeRoutes = true
        options.resourceIdentifier = .routeETA
        options.attributeOptions = [.congestionLevel]
        Directions(restKey: MapplsAccountManager.restAPIKey()).calculate(options) { (waypoints, routes, error) in
            if let _ = error { return }
            
            guard let allRoutes = routes, allRoutes.count > 0 else { return }
            
            self.routes = allRoutes
            DispatchQueue.main.async {
                self.polylinePluginObj = PolylineLayerPlugin(mapView: self.mapView)
                self.polylinePluginObj?.renderRoutePolyline(routes: allRoutes)
            }
        }
    }
    
    @objc func tappedOnMap(_ gesture: UITapGestureRecognizer){
        let selectedRutes = self.polylinePluginObj?.selectRoute(point: gesture.location(in: self.mapView))
        print("selectedRutes::", selectedRutes)
    }
}

//MARK: - MapView Delegates
extension RouteTrafficPolylineSample: MapplsMapViewDelegate {
    
    public func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        displayRoutePolyline()
    }
}
