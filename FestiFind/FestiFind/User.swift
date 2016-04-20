//
//  User.swift
//  FestiFind
//
//  Created by Nino Vrijman on 20/04/16.
//  Copyright © 2016 Nino Vrijman. All rights reserved.
//

import Foundation

public class User {
    var id:Int
    var name:String
    var username:String
    
    var userLocation:UserLocation
    
    init (id : Int, name : String, username : String, userLocation : UserLocation) {
        self.id = 0
        self.name = name
        self.username = username
        self.userLocation = userLocation
    }
    
    func getUserLocation() -> UserLocation {
        return self.userLocation
    }
}
