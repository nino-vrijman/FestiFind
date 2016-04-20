//
//  UserLocation.swift
//  FestiFind
//
//  Created by Nino Vrijman on 20/04/16.
//  Copyright © 2016 Nino Vrijman. All rights reserved.
//

import Foundation

public class Location {
    var longitude:Int
    var latitude:Int
    
    init (longitude : Int, latitude : Int) {
        self.longitude = longitude
        self.latitude = latitude
    }
}