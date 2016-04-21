//
//  BannerViewController.swift
//  FestiFind
//
//  Created by Fhict on 21/04/16.
//  Copyright © 2016 Nino Vrijman. All rights reserved.
//

import UIKit

class BannerViewController: UIViewController {

    @IBOutlet weak var ivArrow: UIImageView!
    
    var timer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()
    //    timer.invalidate() // just in case this button is tapped multiple times
        
        // start the timer
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func update() {
        if(ivArrow.hidden){
            ivArrow.hidden = false;
        }
        else{
            ivArrow.hidden = true;
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
