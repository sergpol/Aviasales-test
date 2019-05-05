//
//  BezierPolyline.swift
//  Aviasales test
//
//  Created by Сергей Полицинский on 05/05/2019.
//  Copyright © 2019 Сергей Полицинский. All rights reserved.
//

import Foundation
import MapKit

class BezierPathPolyline: MKPolyline {
    var points: [MKMapPoint] = []
    
    convenience init(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        self.init(coordinates: [start, end], count: 2)
        
        points = [MKMapPoint(start), MKMapPoint(end)]
    }
}

public extension MKMultiPoint {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                                              count: pointCount)
        
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        
        return coords
    }
}
