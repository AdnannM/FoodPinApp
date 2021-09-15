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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var restaurant: Restaurant!
    
    let locationManage = CLLocationManager()
    var currentPlacemark: CLPlacemark?
    
    var currentTransportType = MKDirectionsTransportType.automobile
    var currentRoute: MKRoute?
    
    let popTransitionPresentaion = PopTransitionAnimator()
    
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        setupSegmentedControl()
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
    
    // MARK: Setup segmentedControl
    private func setupSegmentedControl() {
        segmentedControl.addTarget(self,
                                   action: #selector(showDirection),
                                   for: .valueChanged)
    }
    
    // MARK: - Action Show Direction
    @IBAction func showDirection(sender: UIButton) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: currentTransportType = .automobile
        case 1: currentTransportType = .walking
        default:
            break
        }
        
        segmentedControl.isHidden = false
        
        guard let currentPlacemark = currentPlacemark else {
            return
        }
        
        let directionRequest = MKDirections.Request()
        // Set the source and destionation of the route
        directionRequest.source = MKMapItem.forCurrentLocation()
        
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = currentTransportType
        
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
            self.currentRoute = route
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            
            // MARK: Scale the Map to Fit Route
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
        }
    }
    
    // MARK: Action ShowNearby Restaurant
    @IBAction func showNearby(sender: UIButton) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = restaurant.type
        searchRequest.region = mapView.region
        
        let localSearch = MKLocalSearch(request: searchRequest)
        localSearch.start { localResponse, localError in
            guard let localResponse = localResponse else {
                if let localError = localError {
                    print(localError)
                }
                
                return
            }
            
            let mapItems = localResponse.mapItems
            var nearbyAnnotation: [MKAnnotation] = []
            
            if mapItems.count > 0 {
                for items in mapItems {
                    // Add annotation
                    let annotation = MKPointAnnotation()
                    annotation.title = items.name
                    annotation.subtitle = items.phoneNumber
                    
                    if let location = items.placemark.location {
                        annotation.coordinate = location.coordinate
                    }
                    
                    nearbyAnnotation.append(annotation)
                }
            }
            
            self.mapView.showAnnotations(nearbyAnnotation, animated: true)
        }
    }
}

// MARK: MapViewDelegate Methods
extension MapViewController: MKMapViewDelegate {
    
    // MARK: Draw the route
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = (currentTransportType == .automobile) ?
            UIColor.systemBlue : UIColor.systemGreen
        
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
            
            markerAnnotationView?.glyphImage = UIImage(systemName: "location.north.circle.fill")
            markerAnnotationView?.glyphText = "🍴"
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
        
        annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return annotationView
    }
    
    // MARK: - Handle Touch
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "showSteps", sender: view)
    }
    
    // MARK: - Segue to next RouteVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationVC
        // Pass the selected object to the new VC
        
        if segue.identifier == "showSteps" {
            let routeVC = segue.destination.children[0] as! RouteTableViewController

            if let steps = currentRoute?.steps {
                routeVC.routeSteps = steps
            }
        }
    }
}
