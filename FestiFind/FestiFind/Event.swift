//
//  Event.swift
//  FestiFind
//
//  Created by Nino Vrijman on 20/04/16.
//  Copyright © 2016 Nino Vrijman. All rights reserved.
//

import Foundation

public class Event {
    var id:Int
    var name:String
    var startDateTime:NSDate
    var endDateTime:NSDate
    var eventLocation:EventLocation
    
    init(id : Int, name : String, startDateTime : NSDate, endDateTime : NSDate, eventLocation : EventLocation) {
        self.id = id
        self.name = name
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.eventLocation = eventLocation
    }
}