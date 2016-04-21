//
//  JoinGroupViewController.swift
//  FestiFind
//
//  Created by Fhict on 21/04/16.
//  Copyright © 2016 Nino Vrijman. All rights reserved.
//

import UIKit

class JoinGroupViewController: UITableViewController {

    var eventGroups:Array<EventGroup> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        getEventGroups()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventGroups.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        let currentRow = indexPath.row
        let currentEventGroup = self.eventGroups[currentRow]
        
        cell.textLabel?.text = currentEventGroup.name
        
        return cell

    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let selectedRow = self.tableView.indexPathForSelectedRow
        let selectedGroup = self.eventGroups[selectedRow!.row]
        
        let controller = segue.destinationViewController as! GroupViewController
        controller.selectedEventGroup = selectedGroup
    }
    
    func getEventGroups() {
        let post:NSString = "username=''&password=''"
        
        NSLog("Data sent with post: %@", post);
        
        let url:NSURL = NSURL(string:"https://www.ninovrijman.nl/cgi-bin/jsonlogin_festifind_get_event_groups.php")!
        
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
                let eventGroupsJson:NSArray = jsonData.valueForKey("eventgroups") as! NSArray
                
                for group in eventGroupsJson {
                    let id:Int? = Int(group.valueForKey("id") as! String)
                    let name:String = group.valueForKey("name") as! String
                    eventGroups.append(EventGroup(id: id!, name: name))
                }
                
            } else {
                NSLog("Sign in Failed : Connection Failed")
            }
        } else {
            NSLog("Sign in Failed : Connection Failed")
        }
    }
}
