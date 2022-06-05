//
//  MapViewController.swift
//  Yelp
//
//  Created by Zhaolong Zhong on 10/22/16.
//  
//

import UIKit
import MapKit

@objc protocol MapViewControllerDelegate {
    func mapViewController(mapViewController: MapViewController, didSelect business: Business)
    func mapViewController(mapViewController: MapViewController, regionDidChangeAnimated animated: Bool)
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    static let TAG = NSStringFromClass(MapViewController.self)
    
    @IBOutlet var mapView: MKMapView!
    
    var businesses: [Business] = [] {
        didSet {
            print("businesses didSet in map: \(self.businesses.count)")
            invalidateViews()
        }
    }
    var annotations: [MKAnnotation] = []
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var selectedfBusiness: Business?
    weak var delegate: MapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest


        let span = MKCoordinateSpanMake(0.2, 0.2)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: YLocation.getDefaultLocation().coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
        invalidateViews()
    }
    
    func invalidateViews() {
        if (self.viewIfLoaded != nil) {
            self.mapView.removeAnnotations(self.annotations)
            self.annotations.removeAll()
            
            for i in 0..<self.businesses.count {
                let business = self.businesses[i]
                let newAnnotation = YAnnotation(business: business, index: i + 1)
                self.annotations.append(newAnnotation)
            }
        
            
            self.mapView.addAnnotations(annotations)
        }
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let yAnnotation = annotation as? YAnnotation else {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier:\(yAnnotation.coordinate)"
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? YAnnotationView {
            return annotationView
        }
        
        let annotationView = YAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        annotationView.index = yAnnotation.index
        
        let rightCalloutButton = UIButton(type: .detailDisclosure)
        annotationView.rightCalloutAccessoryView = rightCalloutButton
        rightCalloutButton.addTarget(self, action: #selector(MapViewController.rightCalloutButtonAction(_:)), for: .touchUpInside)
        annotationView.canShowCallout = true
        
        return annotationView
    }
    
    func rightCalloutButtonAction(_ sender: AnyObject?) {
        self.delegate?.mapViewController(mapViewController: self, didSelect: self.selectedfBusiness!)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotationView = view as? YAnnotationView else {
            return
        }
        
        self.selectedfBusiness = self.businesses[annotationView.index - 1]
        annotationView.isOpen = true
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let annotationView = view as? YAnnotationView else {
            return
        }
        
        annotationView.isOpen = false
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.delegate?.mapViewController(mapViewController: self, regionDidChangeAnimated: true)
    }
    
    // MARK - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.mapView.showsUserLocation = true
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.currentLocation == nil {
            self.currentLocation = manager.location
        }
        
        manager.stopUpdatingLocation()
    }

}
