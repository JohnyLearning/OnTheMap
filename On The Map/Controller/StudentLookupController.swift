//
//  StudentLookupController.swift
//  On The Map
//
//  Created by Ivan Hadzhiiliev on 2020-02-16.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class StudentLookupController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        _ = UdacityApi.getStudentLocations() { studentLocationsResponse, error in
            if let studentLocations: [StudentInformation] = studentLocationsResponse?.results {
                var annotations = [MKPointAnnotation]()
                
                for studentInformation in studentLocations {
                    let lat = CLLocationDegrees(studentInformation.latitude)
                    let long = CLLocationDegrees(studentInformation.longitude)
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = studentInformation.firstName
                    let last = studentInformation.lastName
                    let mediaURL = studentInformation.mediaURL
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    annotations.append(annotation)
                }
                self.mapView.addAnnotations(annotations)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
}
