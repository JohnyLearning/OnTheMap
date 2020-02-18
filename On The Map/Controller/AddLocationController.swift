//
//  AddLocationController.swift
//  On The Map
//
//  Created by Ivan Hadzhiiliev on 2020-02-16.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AddLocationController: UIViewController {
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func findButton(_ sender: Any) {
        guard let location = location.text, let url = url.text,
            location != "", url != "" else {
                let alert = UIAlertController(title: "Geolocation", message: "Location and URL cannot be empty", preferredStyle: .alert )
                alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                    return
                }))
                self.present(alert, animated: true, completion: nil)
                return
        }
        activityIndicator.isHidden = false
        let studentLocation = StudentInformation(mapString: location, mediaURL: url)
        findLocation(studentLocation)
    }
    
    func findLocation(_ search: StudentInformation){
        CLGeocoder().geocodeAddressString(search.mapString!) { (placemarks, error) in
            self.activityIndicator.isHidden = true
            guard let firstLocation = placemarks?.first?.location else {
                let alert = UIAlertController(title: "Geolocation", message: "Location not found!", preferredStyle: .alert )
                alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                    return
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            var location = search
            location.latitude = firstLocation.coordinate.latitude
            location.longitude = firstLocation.coordinate.longitude
            self.performSegue(withIdentifier: "SaveLocation", sender: location)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveLocation", let saveLocationController = segue.destination as? SaveLocationController {
            saveLocationController.location = (sender as! StudentInformation)
        }
    }
}
