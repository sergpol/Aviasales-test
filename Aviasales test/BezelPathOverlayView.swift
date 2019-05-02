//
//  PathView.swift
//  Aviasales test
//
//  Created by Сергей Полицинский on 30/04/2019.
//  Copyright © 2019 Сергей Полицинский. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class BezelPathOverlayView: NSObject, MKOverlay {
    
    var boundingMapRect: MKMapRect
    var coordinate: CLLocationCoordinate2D
    
    init(polyline: MKPolyline) {
        boundingMapRect = polyline.boundingMapRect
        coordinate = polyline.coordinate
    }
}
