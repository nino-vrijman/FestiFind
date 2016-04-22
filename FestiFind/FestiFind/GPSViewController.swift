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


class GPSViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet weak var lblmyLocation: UILabel!
    @IBOutlet weak var tvGroupMembers: UITableView!
    
    var groupMembers:Array<User> = []
   
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Het opzetten de locationManager
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //Hiermee wordt gevraagd of de applicatie altijd de locatie mag ophalen
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            tvGroupMembers.delegate = self
            tvGroupMembers.dataSource = self
            
            getGroupMembers()
            
            self.tvGroupMembers.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Als de locatie manager wordt aangeroepen met een update van de locatie
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.theMap.setRegion(region, animated: true)
        //Het label wordt geset met een andere text. Als de text niet geset wordt weet je als gebruiker dat er geen GPS connectie is gelegd
        lblmyLocation.text = "Je vrienden in de buurt:";
        let annotation = MKPointAnnotation()
        //Gebruik van var omdat de lat en long verandert kunnen worden in de toekomst
        var pinCor = CLLocationCoordinate2D(latitude: 51.452816, longitude: 5.480947)
        annotation.title = "Kevin";
        annotation.subtitle = "Bij de waterkraan";
        annotation.coordinate = pinCor
        self.theMap.addAnnotation(annotation)
        //Tweede persoon aanmaken
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
    
    //  Delegate methods van de UITableView zoals deze ook gebruik worden in een TableViewController
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMembers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as UITableViewCell
        
        let currentRow = indexPath.row
        let currentGroupMember = self.groupMembers[currentRow]
        
        cell.textLabel?.text = currentGroupMember.name
        
        return cell
    }
    
    func getGroupMembers() {
        //  Ophalen van de huidige groep waarbij de gebruiker zich aangemeld heeft uit de UserDefaults (/ Shared Preferences equivalent 
        //  van Swift)
        let prefs = NSUserDefaults.standardUserDefaults()
        let groupId:Int = prefs.integerForKey("ACTIVE_GROUP") as Int ?? 0
        NSLog("Group ID: %ld", groupId)
        if (groupId == 0) {
            return
        }
        
        //  Huidige GroupID meesturen
        let post:NSString = "group_id=\(groupId)"
        
        NSLog("Data sent with post: %@", post);
        
        let url:NSURL = NSURL(string:"https://www.ninovrijman.nl/cgi-bin/festifind_get_group_members.php")!
        
        //  Omzetten naar ASCII zodat het over internet gestuurd kan worden en aanmaken van POST "command"
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let postLength:NSString = String( postData.length )
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        var reponseError: NSError?
        var response: NSURLResponse?
        
        //  Opvangen van de return data die de .php pagina terugstuurt  
        var urlData: NSData?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
        } catch let error as NSError {
            reponseError = error
            urlData = nil
        }
        
        if ( urlData != nil ) {
            let res = response as! NSHTTPURLResponse!;
            
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                
                NSLog("Response message (JSON): %@", responseData);
                
                //  De teruggestuurde data is een dictionary in JSON formaat, deze wordt naar NSDictionary gecast zodat er in de code met deze
                //  gegevens gewerkt kan worden.
                var jsonData:NSDictionary = [:]
                //var error: NSError?
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                } catch {
                    
                }
                
                //  Een array van dictionaries (die een groupmember) wordt uit de value van de key "eventgroup_members" gehaald.
                let groupMembersJson:NSArray = jsonData.valueForKey("eventgroup_members") as! NSArray
                
                for member in groupMembersJson {
                    //  De dictionary van een enkele groupmember wordt uitgelezen en omgezet naar een User object.
                    let userId:String = member.valueForKey("ID") as! String
                    let userName:String = member.valueForKey("NAME") as! String
                    let userUsername:String = member.valueForKey("USERNAME") as! String
                    let userIdAsInt:Int? = Int(userId)
                    
                    self.groupMembers.append(User(id: userIdAsInt!, name: userName, username: userUsername, userLocation: UserLocation(longitude: 0.0, latitude: 0.0)))
                }
                tvGroupMembers.reloadData()
                
            } else {
                NSLog("Sign in Failed : Connection Failed")
            }
        } else {
            NSLog("Sign in Failed : Connection Failed")
        }
        
    }


}
