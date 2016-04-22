//
//  LoginViewController.swift
//  FestiFind
//
//  Created by Nino Vrijman on 20/04/16.
//  Copyright © 2016 Nino Vrijman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    //Textfield van username
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    //Textfield van het password
    @IBOutlet weak var tfPasswordSecure: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Deze methode wordt aangeroepen als op de login knop gedrukt wordt
    @IBAction func btnLogin_Touch(sender: UIButton) {
        let username = tfUsername.text!
        let password = tfPasswordSecure.text!
        
        //  Als het inloggen is gelukt dan wordt er naar een nieuw scherm genavigeerd, als dit niet zo is dan krijgt de gebruiker een melding
        //  te zien en kan hij opnieuw proberen om zijn inloggegevens in te voeren.
        if (logIn(username, password: password)) {
            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("MenuViewController")
            self.showViewController(vc as! MenuViewController, sender: vc)
        } else {
            let alertView = UIAlertView(title: "Login not succesful", message: "Incorrect combination of username and password", delegate: nil,cancelButtonTitle: "Try again")
            alertView.show()
        }
    }
    
    func logIn(username : String, password : String) -> Bool {
        //  Meesturen van username en password
        let post:NSString = "username=\(username)&password=\(password)"
        
        NSLog("Data sent with post: %@", post);
        
        let url:NSURL = NSURL(string:"https://www.ninovrijman.nl/cgi-bin/jsonlogin_festifind_returns_user.php")!
        
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
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                } catch {
                    
                }
                
                let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                
                NSLog("Success code (0 = failed, 1 = succeeded): %ld", success);
                
                if(success == 1)
                {
                    NSLog("Login SUCCESS");
                    
                    let userId:Int = jsonData.valueForKey("id") as! Int
                    let userName:String = jsonData.valueForKey("name") as! String
                    let userUsername:String = jsonData.valueForKey("username") as! String
                    let userLat:Double = jsonData.valueForKey("location_lat") as! Double
                    let userLon:Double = jsonData.valueForKey("location_lon") as! Double
                    
                    let loggedInUser = User(id: userId, name: userName, username: userUsername, userLocation: UserLocation(longitude: userLon, latitude: userLat))
 
                    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    prefs.setInteger(loggedInUser.id, forKey: "LOGGEDINUSERID")
                    prefs.synchronize()
                    return true;
                } else {
                    var error_msg:NSString
                    
                    if jsonData["error_message"] as? NSString != nil {
                        error_msg = jsonData["error_message"] as! NSString
                    } else {
                        error_msg = "Unknown Error"
                    }
                    NSLog("Sign in failed : " + (error_msg as String))
                    return false;
                    
                }
                
            } else {
                NSLog("Sign in Failed : Connection Failed")
                return false
            }
        } else {
            NSLog("Sign in Failed : Connection Failed")
            return false
        }
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
