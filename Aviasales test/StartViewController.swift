//
//  StartViewController.swift
//  Aviasales test
//
//  Created by Сергей Полицинский on 30/04/2019.
//  Copyright © 2019 Сергей Полицинский. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var planeImageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        //let frame = CGRect(x: self.view.frame.width, y: planeImageView.frame.origin.y, width: planeImageView.frame.width, height: 0)
        UIView.animate(withDuration: 1.0, animations: {
            self.planeImageView.center.x = self.view.frame.width + self.planeImageView.frame.width
        }, completion: {(finished: Bool) -> Void in
            self.planeImageView.isHidden = true
            self.performSegue(withIdentifier: "StartSegue", sender: self)
        })
    }
}
