//
//  BezelPathOverlay.swift
//  Aviasales test
//
//  Created by Сергей Полицинский on 01/05/2019.
//  Copyright © 2019 Сергей Полицинский. All rights reserved.
//

import Foundation
import MapKit

class BezelPathOverlayRenderer: MKOverlayRenderer {
    var startPoint: CGPoint!
    var finishPoint: CGPoint!
    
    override init(overlay: MKOverlay) {
        super.init(overlay: overlay)
    }
    
    init(overlay: MKOverlay, startPoint: CGPoint, finishPoint: CGPoint) {
        self.startPoint = startPoint
        self.finishPoint = finishPoint
        
        super.init(overlay: overlay)
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let unit = CGFloat(overlay.boundingMapRect.width)
        let normalPosition = startPoint.x < finishPoint.x
        
        let startPoint1 = normalPosition ? CGPoint.zero : CGPoint(x: overlay.boundingMapRect.width, y: 0)
        let finishPoint1 = normalPosition ? CGPoint(x: overlay.boundingMapRect.width, y: overlay.boundingMapRect.height) : CGPoint(x: 0, y: overlay.boundingMapRect.height)
        let k = normalPosition ? unit : -unit
        
//        let bezierPath = UIBezierPath()
//        bezierPath.move(to: startPoint1)
//        bezierPath.addCurve(to: finishPoint1, controlPoint1: CGPoint(x: startPoint1.x + coeff, y: startPoint1.y), controlPoint2: CGPoint(x: finishPoint1.x - coeff, y: finishPoint1.y))
        
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setLineWidth(5 / CGFloat(zoomScale))
        context.setLineDash(phase: 1, lengths: [5 / CGFloat(zoomScale), 10 / CGFloat(zoomScale)])
        context.setStrokeColor(UIColor.aviasalesBlue.cgColor)
        
        let p = CGMutablePath()
        p.move(to: startPoint1)
        p.addCurve(to: finishPoint1, control1: CGPoint(x: startPoint1.x + k, y: startPoint1.y), control2: CGPoint(x: finishPoint1.x - k, y: finishPoint1.y))
        context.addPath(p)
        //context.move(to: startPoint1)
        //context.addCurve(to: finishPoint1, control1: CGPoint(x: startPoint1.x + k, y: startPoint1.y), control2: CGPoint(x: finishPoint1.x - k, y: finishPoint1.y))
        //context.addPath(bezierPath.cgPath)
        context.strokePath()
        
        //context.addLine(to: finishPoint)
        //context.addCurve(to: finishPoint, control1: CGPoint(x: startPoint.x + 160, y: startPoint.y), control2: CGPoint(x: finishPoint.x - 160, y: finishPoint.y))
        
        //context.addPath(p)
        //context.drawPath(using: .fillStroke)
        //context.strokePath()
        
//        if let plainImage = UIImage(named: "plane") {
//            let point = self.calculateCube(t: t, p1: startPoint1, p2: CGPoint(x: startPoint1.x + coeff, y: startPoint1.y), p3: CGPoint(x: finishPoint1.x - coeff, y: finishPoint1.y), p4: finishPoint1)
//            context.draw(plainImage.cgImage!, in: CGRect(x: point.x, y: point.y - 64 / CGFloat(zoomScale), width: 64 / CGFloat(zoomScale), height: 64 / CGFloat(zoomScale)))
//            //context.translateBy(x: point.x, y: point.y)
//        }
        //context.draw(plainImage.cgImage!, in: CGRect(x: startPoint1.x, y: startPoint1.y - 64 / CGFloat(zoomScale), width: 64 / CGFloat(zoomScale), height: 64 / CGFloat(zoomScale)))
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
