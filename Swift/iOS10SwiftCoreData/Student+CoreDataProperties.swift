//
//  Student+CoreDataProperties.swift
//  iOS10SwiftCoreData
//
//  Created by zidonj on 2016/11/28.
//  Copyright © 2016年 zidon. All rights reserved.
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student");
    }

    @NSManaged public var age: Int32
    @NSManaged public var name: String?
    @NSManaged public var number: Int32
    @NSManaged public var sex: String?
    @NSManaged public var person: Person?

}
