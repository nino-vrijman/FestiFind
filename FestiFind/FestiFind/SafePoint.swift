//
//  SafePoint.swift
//  FestiFind
//
//  Created by Nino Vrijman on 20/04/16.
//  Copyright © 2016 Nino Vrijman. All rights reserved.
//

import Foundation

public class SafePoint : Location {
    var alertTimeMinutes:Int
    
    init(longitude : Int, latitude : Int, alertTimeMinutes : Int) {
        self.alertTimeMinutes = alertTimeMinutes
        super.init(longitude: longitude, latitude: latitude)
    }
}
