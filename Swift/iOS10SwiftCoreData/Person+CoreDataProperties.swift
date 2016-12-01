//
//  Person+CoreDataProperties.swift
//  iOS10SwiftCoreData
//
//  Created by zidonj on 2016/11/28.
//  Copyright © 2016年 zidon. All rights reserved.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person");
    }

    @NSManaged public var age: Int64
    @NSManaged public var height: Int64
    @NSManaged public var name: String?
    @NSManaged public var headImage: Data?
    @NSManaged public var student: Student?
    

    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
