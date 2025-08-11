//
//  MGLPolyline+Extension.swift
//  MapplsSDKDemo
//
//  Created by rento on 24/01/25.
//

import MapplsMap
import MapKit

public extension MGLPolyline {
    class func geodesicPolyline(fromCoordinate: CLLocationCoordinate2D, toCoordinate: CLLocationCoordinate2D) -> MGLPolyline {
        var coordinates = [fromCoordinate, toCoordinate]
        let geodesicPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: 2)
        
        var normalizedCoordinates: [CLLocationCoordinate2D] = []
        var previousCoordinate: CLLocationCoordinate2D?
        for coordinate in geodesicPolyline.coordinates {
            var normalizedCoordinate = coordinate
            if let previousCoordinate = previousCoordinate, abs(previousCoordinate.longitude - coordinate.longitude) > 180 {
                if (previousCoordinate.longitude > coordinate.longitude) {
                    normalizedCoordinate.longitude += 360
                } else {
                    normalizedCoordinate.longitude -= 360
                }
            }
            normalizedCoordinates.append(normalizedCoordinate)
            previousCoordinate = normalizedCoordinate
        }
        
        return MGLPolyline(coordinates: normalizedCoordinates, count: UInt(geodesicPolyline.pointCount))
    }
}
