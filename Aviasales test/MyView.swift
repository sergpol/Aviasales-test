//
//  MyView.swift
//  Aviasales test
//
//  Created by Сергей Полицинский on 01/05/2019.
//  Copyright © 2019 Сергей Полицинский. All rights reserved.
//

import Foundation
import UIKit

class MyView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(5)
            context.setStrokeColor(UIColor.red.cgColor)
            
            context.setLineCap(.round)
            context.setLineJoin(.round)
            context.setLineWidth(5.0)
            context.setStrokeColor(UIColor.green.cgColor)
            context.setFillColor(UIColor.white.cgColor)
            
            let start = CGPoint(x: 10, y: 10)
            let p1 = CGPoint(x: start.x + 50, y: start.y)
            let p2 = CGPoint(x: p1.x, y: p1.y + 50)
            let p3 = CGPoint(x: start.x, y: p2.y)
            let points = [start, p1, p2, p3]
            
            context.move(to: start)
            context.addLines(between: points)
            context.closePath()
            context.strokePath()
        }
    }
}
