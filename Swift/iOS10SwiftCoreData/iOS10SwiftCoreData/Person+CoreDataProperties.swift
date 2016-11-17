//
//  Person+CoreDataProperties.swift
//  iOS10SwiftCoreData
//
//  Created by zidonj on 2016/11/9.
//  Copyright © 2016年 zidon. All rights reserved.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person");
    }

    @NSManaged public var name: String?
    @NSManaged public var age: String?
    @NSManaged public var height: String?

}
