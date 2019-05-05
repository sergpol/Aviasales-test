//
//  BezelPathOverlay.swift
//  Aviasales test
//
//  Created by Сергей Полицинский on 01/05/2019.
//  Copyright © 2019 Сергей Полицинский. All rights reserved.
//

import Foundation
import MapKit

class BezierPathOverlayRenderer: MKPolylineRenderer  {
    var startPoint: CGPoint!
    var finishPoint: CGPoint!
    
    override init(overlay: MKOverlay) {
        super.init(overlay: overlay)
    }
    
    init(overlay: MKOverlay, startPoint: CGPoint, finishPoint: CGPoint) {
        super.init(overlay: overlay)
        
        self.startPoint = startPoint
        self.finishPoint = finishPoint
    }
    
    init(polyline: MKPolyline, startPoint: CGPoint, finishPoint: CGPoint) {
        super.init(polyline: polyline)
        
        self.startPoint = startPoint
        self.finishPoint = finishPoint
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let unit = CGFloat(overlay.boundingMapRect.width)
        let normalPosition = finishPoint.x < 0 ? startPoint.x < finishPoint.x : startPoint.x > finishPoint.x

        let startPoint1 = normalPosition ? CGPoint.zero : CGPoint(x: overlay.boundingMapRect.width, y: 0)
        let finishPoint1 = normalPosition ? CGPoint(x: overlay.boundingMapRect.width, y: overlay.boundingMapRect.height) : CGPoint(x: 0, y: overlay.boundingMapRect.height)
        let k = normalPosition ? unit : -unit
    
        context.setLineWidth(5 / CGFloat(zoomScale))
        context.setLineDash(phase: 1, lengths: [5 / CGFloat(zoomScale), 10 / CGFloat(zoomScale)])
        context.setStrokeColor(UIColor.aviasalesBlue.cgColor)

        let p = CGMutablePath()
        p.move(to: startPoint1)
        p.addCurve(to: finishPoint1, control1: CGPoint(x: startPoint1.x + k, y: startPoint1.y), control2: CGPoint(x: finishPoint1.x - k, y: finishPoint1.y))
        context.addPath(p)
        context.strokePath()
        
        var t: CGFloat = 0.0        
        var myPoints: [MKMapPoint] = []
        while t <= 1 {
            let point = self.calculateCube(t: t, p1: startPoint1, p2: CGPoint(x: startPoint1.x + k, y: startPoint1.y), p3: CGPoint(x: finishPoint1.x - k, y: finishPoint1.y), p4: finishPoint1)
            //print("#point: \(point)")
            let mkMapPoint = MKMapPoint(x: Double(point.x) + overlay.boundingMapRect.minX, y: Double(point.y) + overlay.boundingMapRect.minY)
            myPoints.append(mkMapPoint)
            t = t + 0.001
            //context.draw(plainImage.cgImage!, in: CGRect(x: point.x, y: point.y, width: 64 / CGFloat(zoomScale), height: 64 / CGFloat(zoomScale)))
        }
        
        if let myOverlay = overlay as? BezierPathPolyline {
            var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                                                  count: myPoints.count)
            myOverlay.getCoordinates(&coords, range: NSRange(location: 0, length: myPoints.count))
            //print("###\(coords)")
            myOverlay.points = myPoints
        }
    }

    private func calculateCube(t: CGFloat, p1: CGPoint, p2: CGPoint, p3: CGPoint, p4: CGPoint) -> CGPoint {
        let mt = 1 - t
        let mt2 = mt*mt
        let t2 = t*t
        
        let a = mt2*mt
        let b = mt2*t*3
        let c = mt*t2*3
        let d = t*t2
        
        let x = a*p1.x + b*p2.x + c*p3.x + d*p4.x
        let y = a*p1.y + b*p2.y + c*p3.y + d*p4.y
        return CGPoint(x: x, y: y)
    }
}
