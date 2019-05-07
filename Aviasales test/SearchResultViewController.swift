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
    
    var polyline: MKPolyline!
    var planeAnnotation: PlaneAnnotation!
    var planeAnnotationPosition: Int = 0
    var planeDirection: Double?
    var planeAnnotationView: MKAnnotationView!
    
    var displayLink: CADisplayLink?
    
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
        
        let annotation = PlaneAnnotation()
        mapView.addAnnotation(annotation)
        self.planeAnnotation = annotation
        
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Plane")
        
        var coordinates: [CLLocationCoordinate2D] = []
        var t = 0.0
        while t < 1 {
            let coordinate = calculateCube(t: t,
                                      p1: spbCoordinate,
                                      p2: CLLocationCoordinate2D(latitude: placeCoordinate.latitude, longitude: spbCoordinate.longitude),
                                      p3: CLLocationCoordinate2D(latitude: spbCoordinate.latitude, longitude: placeCoordinate.longitude),
                                      p4: placeCoordinate)
            coordinates.append(coordinate)
            t = t + 0.001
        }
        
        polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        
        let rect = polyline.boundingMapRect
        mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60), animated: true)
        
        let displayLink = CADisplayLink(target: self, selector: #selector(updatePlanePosition))
        displayLink.add(to: .main, forMode: RunLoop.Mode.common)
        self.displayLink = displayLink
    }
    
    @objc func updatePlanePosition() {
        let step = 1
        guard planeAnnotationPosition + step < polyline.pointCount else {
            displayLink?.invalidate()
            displayLink = nil
            return
        }

        let points = polyline.points()
        let previousMapPoint = points[planeAnnotationPosition]
        self.planeAnnotationPosition = self.planeAnnotationPosition + step
        let nextMapPoint = points[planeAnnotationPosition]
        
        planeDirection = directionBetweenPoints(sourcePoint: previousMapPoint, nextMapPoint)
        planeAnnotation.coordinate = nextMapPoint.coordinate
        let _ = mapView(mapView, viewFor: planeAnnotation)
    }
    
    private func directionBetweenPoints(sourcePoint: MKMapPoint, _ destinationPoint: MKMapPoint) -> Double {
        let x = destinationPoint.x - sourcePoint.x
        let y = destinationPoint.y - sourcePoint.y
        
        return radiansToDegrees(radians: atan2(y, x))
    }
    
    private func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / Double.pi
    }
    
    private func degreesToRadians(degrees: Double) -> Double {
        return degrees * Double.pi / 180
    }
    
    private func calculateCube(t: Double, p1: CLLocationCoordinate2D, p2: CLLocationCoordinate2D, p3: CLLocationCoordinate2D, p4: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let mt = 1 - t
        let mt2 = mt*mt
        let t2 = t*t
        
        let a = mt2*mt
        let b = mt2*t*3
        let c = mt*t2*3
        let d = t*t2
        
        let x = a*p1.latitude + b*p2.latitude + c*p3.latitude + d*p4.latitude
        let y = a*p1.longitude + b*p2.longitude + c*p3.longitude + d*p4.longitude
        return CLLocationCoordinate2D(latitude: x, longitude: y)
    }
}

extension SearchResultViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 5.0
        renderer.strokeColor = UIColor.aviasalesBlue
        renderer.lineDashPattern = [0, 10]
        return renderer
    }
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is PlaneAnnotation {
            if self.planeAnnotationView == nil {
                self.planeAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Plane")
            }
            self.planeAnnotationView.image = UIImage(named: "plane")
            
            if let direction = planeDirection {
                let angle = CGFloat(degreesToRadians(degrees: direction))
                self.planeAnnotationView?.transform = CGAffineTransform(rotationAngle: angle)
            }
            return self.planeAnnotationView
        }
        else {
            if let title = annotation.title {
                let myAnnotationView = AirportAnnotationView()
                myAnnotationView.titleLabel.text = "\(title ?? "")"
                return myAnnotationView
            }
        }
        
        return MKAnnotationView()
    }
}
