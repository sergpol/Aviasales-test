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
    
    var startPoint: CGPoint = .zero
    var finishPoint: CGPoint = .zero
    var polyline: MKGeodesicPolyline!
    var planeAnnotation: MKPointAnnotation!
    var planeAnnotationPosition: Int = 0
    var planeDirection: Double?
    var bezierPolyline: BezierPathPolyline!
    var planeAnnotationView: MKAnnotationView!
    
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
        
        let annotation = MKPointAnnotation()
        annotation.title = NSLocalizedString("Plane", comment: "Plane marker")
        mapView.addAnnotation(annotation)
        self.planeAnnotation = annotation
        
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Plane")
        
        startPoint = mapView.convert(spbCoordinate, toPointTo: mapView)
        finishPoint = mapView.convert(placeCoordinate, toPointTo: mapView)
        
        let points: [CLLocationCoordinate2D]
        points = [spbCoordinate, placeCoordinate]
        polyline = MKGeodesicPolyline(coordinates: points, count: 2)
        //mapView.addOverlay(polyline)
        
        let mkPoints = [MKMapPoint(spbCoordinate), MKMapPoint(placeCoordinate)]
        bezierPolyline = BezierPathPolyline(points: mkPoints, count: 2)
        mapView.addOverlay(bezierPolyline)
        
        let rect = polyline.boundingMapRect
        var region = MKCoordinateRegion(rect)
        let rectView = mapView.convert(region, toRectTo: mapView)
        
        //region.span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60), animated: true)
        
        updatePlanePosition()
    }
    
    @objc func updatePlanePosition() {
        let step = 5
        guard planeAnnotationPosition + step < bezierPolyline.points.count
            else { return }

        let points = bezierPolyline.points
        let previousMapPoint = points[planeAnnotationPosition]
        self.planeAnnotationPosition = self.planeAnnotationPosition + step
        let nextMapPoint = points[planeAnnotationPosition]

        planeDirection = directionBetweenPoints(sourcePoint: previousMapPoint, nextMapPoint)
        planeAnnotation.coordinate = nextMapPoint.coordinate
        mapView(mapView, viewFor: planeAnnotation)
        
        perform(#selector(updatePlanePosition), with: nil, afterDelay: 0.03)
    }
    
    private func directionBetweenPoints(sourcePoint: MKMapPoint, _ destinationPoint: MKMapPoint) -> Double {
        let x = destinationPoint.x - sourcePoint.x
        let y = destinationPoint.y - sourcePoint.y
        
        return radiansToDegrees(radians: atan2(y, x)).truncatingRemainder(dividingBy: 360)
    }
    
    private func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / Double.pi
    }
    
    private func degreesToRadians(degrees: Double) -> Double {
        return degrees * Double.pi / 180
    }
}

extension SearchResultViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let myOverlay = overlay as? BezierPathPolyline {
            let renderer = BezierPathOverlayRenderer(polyline: bezierPolyline, startPoint: startPoint, finishPoint: finishPoint)
            return renderer
        }

        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 5.0
        renderer.strokeColor = UIColor.aviasalesBlue
        renderer.lineDashPattern = [8, 8]
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {

    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
       updatePlanePosition()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let title = annotation.title {
            if title == "Plane" {
                let planeIdentifier = "Plane"
                
                if self.planeAnnotationView == nil {
                    self.planeAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: planeIdentifier)
                }
                self.planeAnnotationView.image = UIImage(named: "plane")
                
                if let direction = planeDirection {
                    print(CGFloat(degreesToRadians(degrees: direction)))
                    self.planeAnnotationView?.transform = CGAffineTransform(rotationAngle: CGFloat(degreesToRadians(degrees: direction)))
                }
                return self.planeAnnotationView
            }
            else {
                let myAnnotationView = MyAnnotationView()
                myAnnotationView.titleLabel.text = "\(title ?? "")"
                return myAnnotationView
            }
        }
        
        return MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        self.updatePlanePosition()
        
        if let myOverlay = mapView.overlays.first(where: {(overlay) in
            return overlay is BezierPathPolyline
        }) as? BezierPathPolyline {
            self.updatePlanePosition()
        }
    }
}
