//
//  MapController.swift
//  RandomCA
//
//  Created by Student on 15/2/17.
//  Copyright © 2017 zs. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class MapController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var textFieldLocation: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically
        //from a nib.
        textFieldLocation.delegate = self;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let address = textFieldLocation.text;
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address!, completionHandler:
            {(placemarks, error) -> Void in
                if let placemark = placemarks?[0] {
                    self.annotateMap(placemark.location!.coordinate);
                }
                else {
                    self.displayErrorMsg()
                }
                
        })
        
        textField.resignFirstResponder()
        return true
    }
    
    func displayErrorMsg()
    {
        let alert=UIAlertController(title: "Location Not Found!",
                                    message: "Please enter another address", preferredStyle:
            UIAlertControllerStyle.alert);
        
        let OKAction = UIAlertAction(title: "OK", style: .default)
        { (action:UIAlertAction!) in
        }
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil);
    }
    
    func annotateMap (_ newCoordinate : CLLocationCoordinate2D) {
        // set region on the map
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta,
                                                            longDelta)
        
        let myLocation:CLLocationCoordinate2D = newCoordinate
        let theRegion:MKCoordinateRegion =
            MKCoordinateRegionMake(myLocation, theSpan)
        self.mapView.setRegion(theRegion, animated: true)
        self.mapView.mapType = MKMapType.standard
        
        // add annotation
        let myHomePin = MKPointAnnotation()
        myHomePin.coordinate = newCoordinate
        myHomePin.title = textFieldLocation.text
        self.mapView.addAnnotation(myHomePin)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
