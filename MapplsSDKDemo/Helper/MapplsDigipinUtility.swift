//
//  MapplsDigipinUtility.swift
//  MapplsAPIKit
//
//  Created by Siddharth  on 31/01/25.
//  Copyright © 2025 MapmyIndia. All rights reserved.
//

import Foundation
import CoreLocation

@objc public class MapplsDigiPinUtility: NSObject {
    
    @objc public func getDigiPin(from coordinate: CLLocationCoordinate2D) -> String {
        let lat = coordinate.latitude
        let lon = coordinate.longitude
        
        let L1: [[String]] = [
            ["0", "2", "0", "0"],
            ["3", "4", "5", "6"],
            ["G", "8", "7", "M"],
            ["J", "9", "K", "L"]
        ]

        let L2: [[String]] = [
            ["J", "G", "9", "8"],
            ["K", "3", "2", "7"],
            ["L", "4", "5", "6"],
            ["M", "P", "W", "X"]
        ]

        var vDIGIPIN = ""
        
        var r = 0, c = 0
        let minLat = 1.50, maxLat = 39.00
        let minLon = 63.50, maxLon = 99.00
        let latDivBy = 4, lonDivBy = 4
        var latDivDeg: Double = 0, lonDivDeg: Double = 0

        // Check if the coordinates are within range
        if lat < minLat || lat > maxLat {
            print("Latitude Out of range")
            return ""
        }

        if lon < minLon || lon > maxLon {
            print("Longitude Out of range")
            return ""
        }

        var minLatBoundary = minLat
        var maxLatBoundary = maxLat
        var minLonBoundary = minLon
        var maxLonBoundary = maxLon

        for level in 1...10 {
            latDivDeg = (maxLatBoundary - minLatBoundary) / Double(latDivBy)
            lonDivDeg = (maxLonBoundary - minLonBoundary) / Double(lonDivBy)

            // Find the row index
            var nextMaxLat = maxLatBoundary
            var nextMinLat = maxLatBoundary - latDivDeg

            for x in 0..<latDivBy {
                if lat >= nextMinLat && lat < nextMaxLat {
                    r = x
                    break
                } else {
                    nextMaxLat = nextMinLat
                    nextMinLat = nextMaxLat - latDivDeg
                }
            }

            // Find the column index
            var nextMinLon = minLonBoundary
            var nextMaxLon = minLonBoundary + lonDivDeg

            for x in 0..<lonDivBy {
                if lon >= nextMinLon && lon < nextMaxLon {
                    c = x
                    break
                } else {
                    nextMinLon = nextMaxLon
                    nextMaxLon = nextMinLon + lonDivDeg
                }
            }

            if level == 1 {
                if L1[r][c] == "0" {
                    return "Out of Bound"
                }
                vDIGIPIN += L1[r][c]
            } else {
                vDIGIPIN += L2[r][c]
                if level == 3 || level == 6 {
                    vDIGIPIN += "-"
                }
            }

            // Update boundaries for next level
            minLatBoundary = nextMinLat
            maxLatBoundary = nextMaxLat
            minLonBoundary = nextMinLon
            maxLonBoundary = nextMaxLon
        }

        return vDIGIPIN
    }
    
    @objc public func getCoordinate(from digiPin: String) -> CLLocation? {
        let L1: [[String]] = [
            ["0", "2", "0", "0"],
            ["3", "4", "5", "6"],
            ["G", "8", "7", "M"],
            ["J", "9", "K", "L"]
        ]

        let L2: [[String]] = [
            ["J", "G", "9", "8"],
            ["K", "3", "2", "7"],
            ["L", "4", "5", "6"],
            ["M", "P", "W", "X"]
        ]

        let vDigiPin = digiPin.replacingOccurrences(of: "-", with: "")

        if vDigiPin.count != 10 {
            return nil
        }

        var minLat = 1.50, maxLat = 39.00
        var minLng = 63.50, maxLng = 99.00
        let latDivBy = 4, lngDivBy = 4
        var latDivVal: Double, lngDivVal: Double
        var ri = -1, ci = -1
        var lat1 = 0.0, lat2 = 0.0, lng1 = 0.0, lng2 = 0.0

        for (level, char) in vDigiPin.enumerated() {
            ri = -1
            ci = -1
            latDivVal = (maxLat - minLat) / Double(latDivBy)
            lngDivVal = (maxLng - minLng) / Double(lngDivBy)

            var found = false
            let lookupTable = (level == 0) ? L1 : L2

            for r in 0..<latDivBy {
                for c in 0..<lngDivBy {
                    if lookupTable[r][c] == String(char) {
                        ri = r
                        ci = c
                        found = true
                        break
                    }
                }
                if found { break }
            }

            if !found {
                return nil
            }

            lat1 = maxLat - (latDivVal * Double(ri + 1))
            lat2 = maxLat - (latDivVal * Double(ri))
            lng1 = minLng + (lngDivVal * Double(ci))
            lng2 = minLng + (lngDivVal * Double(ci + 1))

            minLat = lat1
            maxLat = lat2
            minLng = lng1
            maxLng = lng2
        }

        let cLat = (lat2 + lat1) / 2
        let cLng = (lng2 + lng1) / 2
       
        return  CLLocation(latitude: cLat, longitude: cLng)
    }

}


