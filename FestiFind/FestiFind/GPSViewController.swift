//
//  GPSViewController.swift
//  FestiFind
//
//  Created by Fhict on 21/04/16.
//  Copyright © 2016 Nino Vrijman. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class GPSViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet weak var lblmyLocation: UILabel!
   
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.theMap.setRegion(region, animated: true)
        lblmyLocation.text = "Je vrienden in de buurt:";
        let annotation = MKPointAnnotation()
        var pinCor = CLLocationCoordinate2D(latitude: 51.452816, longitude: 5.480947)
        annotation.title = "Kevin";
        annotation.subtitle = "Bij de waterkraan";
        annotation.coordinate = pinCor
        self.theMap.addAnnotation(annotation)
        
        let annotation2 = MKPointAnnotation()
        var pinCor2 = CLLocationCoordinate2D(latitude: 51.450816, longitude: 5.480947)
        annotation2.title = "Nino";
        annotation2.subtitle = "Fissa @ skrillex";
        annotation2.coordinate = pinCor2
        self.theMap.addAnnotation(annotation2)
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
