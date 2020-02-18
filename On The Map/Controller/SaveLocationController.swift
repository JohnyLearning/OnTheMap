//
//  SaveLocationController.swift
//  On The Map
//
//  Created by Ivan Hadzhiiliev on 2020-02-16.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SaveLocationController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var location: StudentInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        showLocation()
    }
    
    private func showLocation() {
        guard let location = location else { return }
        let latitude = CLLocationDegrees(location.latitude!)
        let longitude = CLLocationDegrees(location.longitude!)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location.mapString
        annotation.subtitle = location.mediaURL
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func finishLocation(_ sender: Any) {
        if let studentInformation = self.location {
            UdacityApi.createStudentLocation(studentInformation: studentInformation) { (objectId, error)  in
                guard error == nil else {
                    self.showError(title: "Save location", message: error?.localizedDescription)
                    return
                }
                if let objectId = objectId {
                    DispatchQueue.main.async {
                        if let Controller = self.storyboard?.instantiateViewController(withIdentifier: "StudentTabBar") {
                            self.present(Controller, animated: true, completion: nil)
                        }
                    }
                } else {
                    self.showError(title: "Save location", message: nil)
                    return
                }
            }
        }
    }
    
}

extension SaveLocationController: MKMapViewDelegate {
    
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
