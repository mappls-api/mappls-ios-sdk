//
//  CustomPointAnnotation.swift

//
//  Created by apple on 17/12/18.
//  Copyright © 2022 Mappls. All rights reserved.
//

import Foundation
import MapplsMap


class CustomPointAnnotationEloc: MapplsPointAnnotation {
    var image: UIImage?
    var reuseIdentifier: String?
    var placeName: String?

}

class CustomPointAnnotation: NSObject, MGLAnnotation {
    var mapplsPin: String?
    
    func updateMapplsPin(_ atMapplsPin: String, completionHandler completion: ((Bool, String?) -> Void)? = nil) {
        
    }
    
    // As a reimplementation of the MGLAnnotation protocol, we have to add mutable coordinate and (sub)title properties ourselves.
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    // Custom properties that we will use to customize the annotation's image.
    var image: UIImage?
    var reuseIdentifier: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String? ) {
        self.coordinate = coordinate
        self.title = title
        self.mapplsPin = title
        self.subtitle = subtitle
        
    }
}
