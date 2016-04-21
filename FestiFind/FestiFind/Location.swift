//
//  UserLocation.swift
//  FestiFind
//
//  Created by Nino Vrijman on 20/04/16.
//  Copyright © 2016 Nino Vrijman. All rights reserved.
//

import Foundation

public class Location {
    var longitude:Double
    var latitude:Double
    
    init (longitude : Double, latitude : Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
}