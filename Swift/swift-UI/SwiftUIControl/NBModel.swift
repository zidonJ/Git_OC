//
//  NBModel.swift
//  SwiftUIControl
//
//  Created by zidonj on 2017/1/19.
//  Copyright © 2017年 zidon. All rights reserved.
//

import UIKit
import ObjectMapper

class NBModel: Mappable {
    
    var username: String?
    var age: Int?
    var weight: Double!
    var array: [AnyObject]?
    var dictionary: [String : AnyObject] = [:]
    var bestFriend: NBModel?                       // Nested User object
    var friends: [NBModel]?                        // Array of Users
    var birthday: Date?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        username    <- map["username"]
        age         <- map["age"]
        weight      <- map["weight"]
        array       <- map["arr"]
        dictionary  <- map["dict"]
        bestFriend  <- map["best_friend"]
        friends     <- map["friends"]
        birthday    <- (map["birthday"], DateTransform())
    }
    
    
    
}
