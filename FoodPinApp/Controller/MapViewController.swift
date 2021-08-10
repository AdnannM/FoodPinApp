//
//  MapViewController.swift
//  FoodPinApp
//
//  Created by Adnann Muratovic on 09.08.21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    var restaurant: Restaurant!
    
    let locationManage = CLLocationManager()
    var currentPlacemark: CLPlacemark?
    
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        authorizationLocationServices()
        setupMapKit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Request User's authorization for location service
    private func authorizationLocationServices() {
        locationManage.requestAlwaysAuthorization()
        
        if #available(iOS 14, *) {
            let status = CLLocationManager.authorizationStatus()
            
            if status == CLAuthorizationStatus.authorizedWhenInUse {
                mapView.showsUserLocation = true
            }
        }
    }
    
    // MARK: Convert address to coordinate get the first placemark, add annotation Display annotation
    private func setupMapKit() {
        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location) { placemarks, error in
            if let error = error {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                self.currentPlacemark = placemark
                
                // Add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    // Display annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
        
        mapView.delegate = self
        mapView.showsTraffic = true
        mapView.showsScale = true
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.isZoomEnabled = true
    }
    
    // MARK: - Action
    @IBAction func showDirection(sender: UIButton) {
        guard let currentPlacemark = currentPlacemark else {
            return
        }
        
        let directionRequest = MKDirections.Request()
        // Set the source and destionation of the route
        directionRequest.source = MKMapItem.forCurrentLocation()
        
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        directions.calculate { routeResponse, routeError in
            guard let routeResponse = routeResponse else {
                if let routeError = routeError {
                    print(routeError)
                }
                return
            }
            
            let route = routeResponse.routes[0]
            self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            
            // MARK: Scale the Map to Fit Route
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
        }
    }
}

// MARK: MapViewDelegate Methods
extension MapViewController: MKMapViewDelegate {
    
    // MARK: Draw the route
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = UIColor.blue
        render.lineWidth = 3.0
        
        return render
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView: MKAnnotationView?
        
        if #available(iOS 11, *) {
            var markerAnnotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if markerAnnotationView == nil {
                markerAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                markerAnnotationView?.canShowCallout = true
            }
            
            markerAnnotationView?.glyphText = "🤗"
            markerAnnotationView?.glyphTintColor = UIColor.orange
            
            annotationView = markerAnnotationView
        } else {
            var pinAnnotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            
            if pinAnnotationView == nil {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinAnnotationView?.canShowCallout = true
                pinAnnotationView?.pinTintColor = UIColor.orange
            }
            
            annotationView = pinAnnotationView
        }
        
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
        leftIconView.image = UIImage(named: restaurant.image)
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        return annotationView
    }
}
