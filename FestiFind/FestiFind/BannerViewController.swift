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
    //In swift is het niet mogelijk om een gif te tonen. De timer zorgt er voor dat de afdeling gaat flikkeren
    var timer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // start the timer met een interval van 0,5 seconde
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func update() {
        //Kijken of de image al gehidden is
        if(ivArrow.hidden){
            //de image is hidden, toont de image nu
            ivArrow.hidden = false;
        }
        else{
            //de image is visible, hide de image nu
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
