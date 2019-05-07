//
//  MyView.swift
//  Aviasales test
//
//  Created by Сергей Полицинский on 01/05/2019.
//  Copyright © 2019 Сергей Полицинский. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AirportAnnotationView: MKAnnotationView {
    var titleLabel = UILabel(frame: CGRect(x: -24, y: -16, width: 58, height: 32))
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func setupView() {
        titleLabel.textAlignment = .center
        titleLabel.textColor = .aviasalesBlue
        titleLabel.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        //titleLabel.sizeToFit()
        
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = titleLabel.frame.height / 2
        titleLabel.layer.borderWidth = 2
        titleLabel.layer.borderColor = UIColor.aviasalesBlue.cgColor
        
        self.addSubview(titleLabel)
    }
}
