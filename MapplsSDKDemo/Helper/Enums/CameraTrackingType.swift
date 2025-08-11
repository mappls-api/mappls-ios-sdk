//
//  CameraTrackingType.swift
//  MapplsSDKDemo
//
//  Created by rento on 31/01/25.
//

import Foundation

enum CameraTrackingType {
    static var title: String {
        return "Choose Tracking"
    }
    
    case none, noneCompass, tracking, trackingCompass, trackingGPS, trackingGPSNorth
    
    var rawValue: String {
        switch self {
        case .none:
            return "None"
        case .noneCompass:
            return "None Compass"
        case .tracking:
            return "Tracking"
        case .trackingCompass:
            return "Tracking Compass"
        case .trackingGPS:
            return "Tracking GPS"
        case .trackingGPSNorth:
            return "Tracking GPS North"
        }
    }
    
    var abbreviated: String {
        switch self {
        case .none:
            return "None"
        case .noneCompass:
            return "None Compass"
        case .tracking:
            return "Tracking"
        case .trackingCompass:
            return "T. Compass"
        case .trackingGPS:
            return "T. GPS"
        case .trackingGPSNorth:
            return "T. GPS North"
        }
    }
    
    static var allItems: [CameraTrackingType] {
        return [.none, .noneCompass, .tracking, .trackingCompass, .trackingGPS, .trackingGPSNorth]
    }
    
    var count: Int {
        return 6
    }
}
