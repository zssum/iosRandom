//
//  ViewController.swift
//  RandomCA
//
//  Created by Student on 15/2/17.
//  Copyright © 2017 zs. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class ViewController: UIViewController, UITextFieldDelegate,CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource  {
    
    var locationManager:CLLocationManager!
    
    @IBOutlet weak var textFieldLocation: UITextField!
    
    @IBOutlet weak var labelLatitude: UILabel!
    
    @IBOutlet weak var labelLongitude: UILabel!
    
    @IBOutlet weak var labelDistance: UILabel!

    @IBOutlet weak var mapView: MKMapView!
    
    var places:Array< String>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically
        //from a nib.
        self.mapView.showsUserLocation=true //please enable location on device to show your own location
        locationManager=CLLocationManager();
        locationManager.delegate=self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.requestAlwaysAuthorization();
        locationManager.startUpdatingLocation();
        places=["","NUS Engineering","NUS Science","NUS Arts"]
        let pickerView:UIPickerView=UIPickerView()
        pickerView.delegate=self
        pickerView.dataSource=self
        textFieldLocation.inputView=pickerView
        labelLatitude.text="";
        labelLongitude.text="";
        textFieldLocation.delegate = self;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let address = textFieldLocation.text;
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address!, completionHandler:
            {(placemarks, error) -> Void in
                if let placemark = placemarks?[0] {
                    let latitude:Double =
                        placemark.location!.coordinate.latitude;
                    let longitude:Double =
                        placemark.location!.coordinate.longitude;
                    self.labelLatitude.text = NSString(format: "%.8f",
                                                       latitude) as String;
                    self.labelLongitude.text = NSString(format: "%.8f",
                                                        longitude) as String;
                    
                    
                    self.annotateMap(placemark.location!.coordinate);
                }
                else {
                    self.displayErrorMsg()
                }
                
        })
        
        textField.resignFirstResponder()
        return true
    }
    
    func annotateMap (_ newCoordinate : CLLocationCoordinate2D) {

        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        // set region on the map
        let latDelta:CLLocationDegrees = 0.05
        let longDelta:CLLocationDegrees = 0.05
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
        
        let distance :CLLocationDistance = (locationManager.location?.distance(from: CLLocation.init(latitude: myLocation.latitude, longitude: myLocation.longitude)))!
        let distanceInKm = distance/1000
        labelDistance.text = "Approx Straight-line Distance:"+String(format:"%.1f",distanceInKm)+" km"
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation=locations.last?.description as String!
        print(lastLocation!)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return places!.count;
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return places![row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(places![row] + "selected");
        textFieldLocation.text=places![row]
        self.view.endEditing(true)
        self.textFieldShouldReturn(textFieldLocation)
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
