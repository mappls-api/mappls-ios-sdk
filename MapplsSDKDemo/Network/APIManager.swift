//
//  APIManager.swift
//  MapplsSDKDemo
//
//  Created by rento on 13/01/25.
//

import Foundation
import MapplsAPIKit

struct APIManager {
    
    static func reverseGeocode(options: MapplsReverseGeocodeOptions, success: @escaping ([MapplsGeocodedPlacemark]?) -> (), failure: @escaping (NSError) -> ()) {
        let reverseGeocodeManager = MapplsReverseGeocodeManager.shared
        reverseGeocodeManager.reverseGeocode(options) { (placemarks, attribution, error) in
            if let error = error {
                failure(error)
            } else {
                success(placemarks)
            }
        }
    }
    
    static func getNearBySuggestions(options: MapplsNearbyAtlasOptions, success: @escaping ([MapplsAtlasSuggestion]?) -> (), failure: @escaping (NSError) -> ()) {
        let nearByManager = MapplsNearByManager.shared
        nearByManager.getNearBySuggestions(options) { (result, error) in
            if let error = error {
                failure(error)
            } else if let result = result {
                success(result.suggestions)
            }
        }
    }
    
    static func placeDetail(option: MapplsPlaceDetailOptions, success: @escaping (MapplsPlaceDetail?) -> Void, failure: @escaping (NSError) -> ()) {
        let placeDetailManager = MapplsPlaceDetailManager.shared
        placeDetailManager.getResults(option) { (placeDetail, error) in
            if let error = error {
                failure(error)
            } else {
                success(placeDetail)
            }
        }
    }
    
    static func getGeocodeResults(option: MapplsAtlasGeocodeOptions, success: @escaping ([MapplsAtlasGeocodePlacemark]?) -> (), failure: @escaping (NSError) -> ()) {
        let atlasGeocodeManager = MapplsAtlasGeocodeManager.shared
        atlasGeocodeManager.getGeocodeResults(option) { (response, error) in
            if let error = error {
                failure(error)
            } else if let result = response {
                success(result.placemarks)
            }
        }
    }
 
    static func getRoute(options: RouteOptions, succcess: @escaping (_ routes: [Route]?, _ waypoints: [Waypoint]?) -> (), failure: @escaping (NSError) -> ()) {
        let _ = Directions.shared.calculate(options) { (waypoints, routes, error) in
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }

            if let error = error {
                failure(error)
            }else {
                succcess(routes, waypoints)
            }
        }
    }
    
    static func getDistanceTimeMatrix(option: MapplsDrivingDistanceMatrixOptions, success: @escaping (MapplsDrivingDistanceMatrixResults?) -> (), failure: @escaping (NSError) -> ()) {
        let distanceMatrixManager = MapplsDrivingDistanceMatrixManager.shared
        
        distanceMatrixManager.getResult(option) { (result, error) in
            if let error = error {
                failure(error)
            } else if let result = result {
                success(result.results)
            }
        }
    }
    
    static func poiAlongRoute(option: MapplsPOIAlongTheRouteOptions, success: @escaping ([MapplsPOISuggestion]?) -> (), failure: @escaping (NSError) -> ()) {
        let poiAlongTheRouteManager = MapplsPOIAlongTheRouteManager.shared

        poiAlongTheRouteManager.getPOIsAlongTheRoute(option) { (suggestions, error) in
            if let error = error {
                failure(error)
            } else {
                success(suggestions?.suggestions)
            }
        }
    }
    
    static func getNearbyReports(option: MapplsNearbyReportOptions, success: @escaping (MapplsNearbyReportResponse?) -> (), failure: @escaping (NSError) -> ()) {
        let nearbyReportManager = MapplsNearbyReportManager.shared
        
        nearbyReportManager.getNearbyReportResult(option) { (response, error) in
            if let error = error {
                failure(error)
            } else {
                success(response)
            }
        }
    }
    
    static func currentWeatherConditionAPI(option: MapplsWeatherRequestOptions, success: @escaping (MapplsWeatherResponse?) -> (), failure: @escaping (NSError) -> ()) {
        MapplsWeatherManager.shared.getResults(option) { weatherResponse, error in
            if let error = error {
                failure(error)
            }else {
                success(weatherResponse)
            }
        }
    }
}
