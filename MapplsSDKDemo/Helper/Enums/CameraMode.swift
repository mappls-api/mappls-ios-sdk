//
//  CameraMode.swift
//  MapplsSDKDemo
//
//  Created by rento on 31/01/25.
//

import Foundation

enum CameraMode {
    static var title: String {
        return "Choose Mode"
    }
    
    case normal, compass, gps
    
    var rawValue: String {
        switch self {
        case .normal:
            return "Normal"
        case .compass:
            return "Compass"
        case .gps:
            return "GPS"
        }
    }
    
    var count: Int {
        return 3
    }
    
    static var allItems: [CameraMode] {
        return [.normal, .compass, .gps]
    }
}
