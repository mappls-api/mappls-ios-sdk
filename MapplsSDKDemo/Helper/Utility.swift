//
//  Utility.swift
//  MapplsSDKDemo
//
//  Created by rento on 07/01/25.
//

import Foundation
import MapplsAPIKit
import FittedSheets

class Utility {
    class func polygonCircleForCoordinate(coordinate: CLLocationCoordinate2D, withMeterRadius: Double) -> [CLLocationCoordinate2D] {
        let degreesBetweenPoints = 8.0
        //45 sides
        let numberOfPoints = floor(360.0 / degreesBetweenPoints)
        let distRadians: Double = withMeterRadius / 6371000.0
        // earth radius in meters
        let centerLatRadians: Double = coordinate.latitude * Double.pi / 180
        let centerLonRadians: Double = coordinate.longitude * Double.pi / 180
        var coordinates = [CLLocationCoordinate2D]()
        //array to hold all the points
        for index in 0 ..< Int(numberOfPoints) {
            let degrees: Double = Double(index) * Double(degreesBetweenPoints)
            let degreeRadians: Double = degrees * Double.pi / 180
            let pointLatRadians: Double = asin(sin(centerLatRadians) * cos(distRadians) + cos(centerLatRadians) * sin(distRadians) * cos(degreeRadians))
            let pointLonRadians: Double = centerLonRadians + atan2(sin(degreeRadians) * sin(distRadians) * cos(centerLatRadians), cos(distRadians) - sin(centerLatRadians) * sin(pointLatRadians))
            let pointLat: Double = pointLatRadians * 180 / Double.pi
            let pointLon: Double = pointLonRadians * 180 / Double.pi
            let point: CLLocationCoordinate2D = CLLocationCoordinate2DMake(pointLat, pointLon)
            coordinates.append(point)
        }
        return coordinates
    }
    
    class func createSemicirclePolyline(center: CLLocationCoordinate2D, radius: Double, startAngle: Double, endAngle: Double) -> [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D] = []
        let numPoints = 50
        
        for i in 0...numPoints {
            let angle = startAngle + (endAngle - startAngle) * Double(i) / Double(numPoints)
            let lat = center.latitude + (radius / 111000) * cos(angle * .pi / 180)  // Convert meters to degrees
            let lon = center.longitude + (radius / (111000 * cos(center.latitude * .pi / 180))) * sin(angle * .pi / 180)
            coordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
        
        return coordinates
    }
    
    class func openSheetViewController(from parent: UIViewController, in view: UIView?, controller: UIViewController, size: [SheetSize], sheetOptions: SheetOptions? = nil, dismissOnPullOrTap: Bool = false) -> SheetViewController {
        let useInlineMode = view != nil
        
        var options = SheetOptions(useInlineMode: useInlineMode)
        options.pullBarHeight = 0
        options.presentingViewCornerRadius = 0
        
        if let sheetOptions = sheetOptions {
            options = sheetOptions
        }
        
        let sheet = SheetViewController(
            controller: controller,
            sizes: size,
            options: options)
        sheet.allowPullingPastMaxHeight = false
        sheet.allowPullingPastMinHeight = false
        sheet.dismissOnPull = dismissOnPullOrTap
        sheet.dismissOnOverlayTap = dismissOnPullOrTap
        sheet.pullBarBackgroundColor = .clear
        
        sheet.cornerRadius = 0
        if let view = view {
            sheet.animateIn(to: view, in: parent)
        } else {
            parent.present(sheet, animated: true, completion: nil)
        }
        return sheet
    }
}
