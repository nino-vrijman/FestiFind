//
//  EventGroup.swift
//  FestiFind
//
//  Created by Nino Vrijman on 20/04/16.
//  Copyright © 2016 Nino Vrijman. All rights reserved.
//

import Foundation

public class EventGroup {
    var id:Int
    var name:String
    var groupMembers:Array<User>
    
    init(id : Int, name : String) {
        self.id = id
        self.name = name
        self.groupMembers = []
    }
    
    func addUserToGroup(toBeAddedUser : User) -> Bool {
        return true
    }
}
