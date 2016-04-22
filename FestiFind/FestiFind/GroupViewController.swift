//
//  GroupViewController.swift
//  FestiFind
//
//  Created by Nino Vrijman on 21/04/16.
//  Copyright © 2016 Nino Vrijman. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedEventGroup:EventGroup?
    var groupMembers:Array<User> = []

    @IBOutlet weak var lblGroupname: UILabel!
    @IBOutlet weak var tvGroupMembers: UITableView!
    @IBOutlet weak var btnJoinGroup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblGroupname.text = selectedEventGroup?.name
        
        getGroupMembers()
        
        //  Aangeven dat de delegate methodes (die zich onderaan deze klasse bevinden) in deze Controller klasse te vinden zijn.
        tvGroupMembers.delegate = self
        tvGroupMembers.dataSource = self
        
        let userId = getLoggedInUserId()
        var hasAlreadyJoinedGroup:Bool = false
        for groupMember in groupMembers {
            if (groupMember.id == userId) {
                hasAlreadyJoinedGroup = true
            }
        }
        if (hasAlreadyJoinedGroup) {
            btnJoinGroup.enabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getGroupMembers() {
        //  Huidige GroupID meesturen
        let post:NSString = "group_id=\(selectedEventGroup!.id)"
        
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
                
                //  Een array van dictionaries (die een groupmember) wordt uit de value van de key "eventgroup_members" gehaald.
                let groupMembersJson:NSArray = jsonData.valueForKey("eventgroup_members") as! NSArray
                
                if (!groupMembers.isEmpty) {
                    groupMembers.removeAll()
                }
                
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
    
    @IBAction func btnJoinGroup_Click(sender: AnyObject) {
        let userId:Int = getLoggedInUserId()
        if (addUserToGroup(userId)) {
            let alertView = UIAlertView(title: "Joined group", message: "You have successfully joined the group", delegate: nil,cancelButtonTitle: "Proceed")
            alertView.show()
            getGroupMembers()
            tvGroupMembers.reloadData()
            btnJoinGroup.enabled = false
            
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            prefs.setInteger(selectedEventGroup!.id, forKey: "ACTIVE_GROUP")
            prefs.synchronize()
        } else {
            let alertView = UIAlertView(title: "Join group failed", message: "The group doesn't want you to join, you can try again though ;)", delegate: nil,cancelButtonTitle: "Try again")
            alertView.show()
        }
    }
    
    func getLoggedInUserId() -> Int! {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey("LOGGEDINUSERID")
    }
    
    func addUserToGroup(userId : Int) -> Bool {
        let post:NSString = "userId=\(userId)&eventGroupId=\(selectedEventGroup!.id)"
        
        NSLog("Data sent with post: %@", post);
        
        let url:NSURL = NSURL(string:"https://www.ninovrijman.nl/cgi-bin/festifind_join_group.php")!
        
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

}
