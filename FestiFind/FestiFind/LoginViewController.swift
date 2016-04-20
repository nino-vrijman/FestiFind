//
//  LoginViewController.swift
//  FestiFind
//
//  Created by Nino Vrijman on 20/04/16.
//  Copyright © 2016 Nino Vrijman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLogin_Touch(sender: UIButton) {
        let username = tfUsername.text!
        let password = tfPassword.text!
        if (logIn(username, password: password)) {
            let alertView = UIAlertView(title: "Login succesful", message: "Correct combination of username and password", delegate: nil,cancelButtonTitle: "Proceed")
            alertView.show()
        } else {
            let alertView = UIAlertView(title: "Login not succesful", message: "Incorrect combination of username and password", delegate: nil,cancelButtonTitle: "Try again")
            alertView.show()
        }
    }
    
    func logIn(username : String, password : String) -> Bool {
        let post:NSString = "username=\(username)&password=\(password)"
        
        NSLog("Data sent with post: %@", post);
        
        let url:NSURL = NSURL(string:"https://www.ninovrijman.nl/cgi-bin/jsonlogin_festifind.php")!
        
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
                
                
                var jsonData:NSDictionary = [:]
                //var error: NSError?
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                } catch {
                    
                }
                
                
                let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                
                //[jsonData[@"success"] integerValue];
                
                NSLog("Success code (0 = failed, 1 = succeeded): %ld", success);
                
                if(success == 1)
                {
                    NSLog("Login SUCCESS");
                    
                    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    prefs.setObject(username, forKey: "USERNAME")
                    prefs.setInteger(1, forKey: "ISLOGGEDIN")
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
