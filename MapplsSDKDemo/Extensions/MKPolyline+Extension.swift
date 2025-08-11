//
//  MKPolyline+Extension.swift
//  MapplsSDKDemo
//
//  Created by rento on 24/01/25.
//

import MapKit

public extension MKPolyline {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: self.pointCount)
        self.getCoordinates(&coords, range: NSRange(location: 0, length: self.pointCount))
        return coords
    }
}

