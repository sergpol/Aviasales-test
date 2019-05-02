//
//  SearchResultViewController.swift
//  Aviasales test
//
//  Created by Сергей Полицинский on 30/04/2019.
//  Copyright © 2019 Сергей Полицинский. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SearchResultViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var spbCoordinate = CLLocationCoordinate2D(latitude: 59.806084, longitude: 30.3083)
    var placeCoordinate: CLLocationCoordinate2D!
    var place: AirportPlace! {
        didSet {
            placeCoordinate = CLLocationCoordinate2D(latitude: place.location.lat, longitude: place.location.lon)
        }
    }
    var line = CAShapeLayer()
    var planeImageView = UIImageView()
    var animation = CAKeyframeAnimation(keyPath: "position")
    
    var startPoint: CGPoint = .zero
    var finishPoint: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let spbPointAnnotation = MKPointAnnotation()
        spbPointAnnotation.coordinate = spbCoordinate
        spbPointAnnotation.title = "LED"
        mapView.addAnnotation(spbPointAnnotation)
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = placeCoordinate
        pointAnnotation.title = place.iata
        mapView.addAnnotation(pointAnnotation)
        
        let points: [CLLocationCoordinate2D]
        points = [spbCoordinate, placeCoordinate]
        let polyline = MKPolyline(coordinates: points, count: 2)
        
        let rect = polyline.boundingMapRect
        //var region = MKCoordinateRegion(rect)
        //region.span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60), animated: true)
        
        startPoint = mapView.convert(spbCoordinate, toPointTo: view)
        finishPoint = mapView.convert(placeCoordinate, toPointTo: view)
        
        //mapView.addOverlay(polyline)
        
        planeImageView.frame = CGRect(x: startPoint.x - 14, y: startPoint.y - 14, width: 28, height: 28)
        planeImageView.image = UIImage(named: "plane")
        
        animation.rotationMode = .rotateAuto
        animation.duration = 4
        animation.isRemovedOnCompletion = false
        //planeImageView.layer.add(animation, forKey: "path")
        view.addSubview(planeImageView)
    
        let bezelPathOverlay = BezelPathOverlayView(polyline: polyline)
        self.mapView.addOverlay(bezelPathOverlay)
        
        drawBezelPath()
//        UIView.animate(withDuration: 3, delay: 1, options: [], animations: {
//            planeImageView.frame = CGRect(x: finishPoint.x - 14, y: finishPoint.y - 14, width: 28, height: 28)
//        }, completion: nil)
        
//        let myView = MyView(frame: CGRect(x: 0, y: 100, width: 200, height: 200))
//        myView.backgroundColor = .white
//        view.addSubview(myView)
    }
    
    func drawBezelPath() {
        line.removeFromSuperlayer()
        //planeImageView.removeFromSuperview()
        
        startPoint = mapView.convert(spbCoordinate, toPointTo: view)
        finishPoint = mapView.convert(placeCoordinate, toPointTo: view)
        
        planeImageView.frame = CGRect(x: startPoint.x - 14, y: startPoint.y - 14, width: 28, height: 28)
        
        let bezelPath = UIBezierPath()
        bezelPath.move(to: startPoint)
        
        let k: CGFloat = startPoint.x < finishPoint.x ? finishPoint.x : -startPoint.x
        bezelPath.addCurve(to: finishPoint, controlPoint1: CGPoint(x: startPoint.x + k, y: startPoint.y), controlPoint2: CGPoint(x: finishPoint.x - k, y: finishPoint.y))
        //bezelPath.close()
        
        line = CAShapeLayer()
        line.path = bezelPath.cgPath
        line.lineDashPattern = [5, 10]
        line.fillColor = UIColor.clear.cgColor
        line.strokeColor = UIColor.blue.cgColor
        line.lineWidth = 5
        
        view.layer.addSublayer(line)
        animation.path = bezelPath.cgPath
        
        line.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.planeImageView.isHidden = false
            self.planeImageView.layer.add(self.animation, forKey: "path")
        })
    }
}

extension SearchResultViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let myOverlay = overlay as? BezelPathOverlayView {
            let renderer = BezelPathOverlayRenderer(overlay: myOverlay, startPoint: startPoint, finishPoint: finishPoint)
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//        drawBezelPath()
        line.isHidden = true
        //planeImageView.layer.speed = 0
        planeImageView.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        drawBezelPath()
        //planeImageView.layer.speed = 1
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let title = annotation.title {
            let myAnnotationView = MyAnnotationView()
            myAnnotationView.titleLabel.text = "\(title ?? "")"
            return myAnnotationView
        }
        
        return MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
    }
}
