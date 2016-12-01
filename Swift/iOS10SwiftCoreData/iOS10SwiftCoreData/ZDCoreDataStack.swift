//
//  ZDCoreDataStack.swift
//  iOS10SwiftCoreData
//
//  Created by zidonj on 2016/11/9.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit
import CoreData

class ZDCoreDataStack: NSObject {
    
    let recordStack:CoreDataConifgration=CoreDataConifgration.instance
    
    lazy var person:Person={
        [weak self] in
        let pes:Person=NSEntityDescription.insertNewObject(forEntityName: "Person", into: (self?.recordStack.context)!) as! Person
        return pes
    }()
    
    lazy var student:Student={
        [weak self] in
        let stu:Student=NSEntityDescription.insertNewObject(forEntityName: "Student", into: (self?.recordStack.context)!) as! Student
        return stu
    }()
    
    
    init(dataName:String,storeType:String) {
        super.init()
        recordStack.dataName=dataName
        recordStack.storeType=storeType
    }
}

extension ZDCoreDataStack{
    func saveData(paramter:Dictionary<String, Any>, enity:NSManagedObject) -> Bool {
        
        enity.setValuesForKeys(paramter)
        
        do {
            try self.recordStack.context.save()
        } catch _ {
            print("存储失败",#line)
        }
        return true
    }
    
    func deleteData() -> Bool {
        return true
    }
    
    func updateData() -> Bool {
        return true
    }
    
    func fetchData(enity:String, ascendBy:String, ascending:Bool) -> Array<Any>?{
        return self.makeFetchRequest(enity: enity, ascendBy: ascendBy, ascending: ascending)
    }
    
    private func makeFetchRequest(enity:String, ascendBy:String, ascending:Bool) -> Array<Any>?{
        let request=NSFetchRequest<NSFetchRequestResult>(entityName: enity)
        request.sortDescriptors=[NSSortDescriptor.init(key: ascendBy, ascending: ascending)]
//        var fetchContent:Array<Any>?=nil
//        do {
//            fetchContent = try self.recordStack.context.fetch(request)
//            
//        } catch _ {
//            print("查询错误",#line)
//        }
        let fetchContent = try! self.recordStack.context.fetch(request)
        return fetchContent
    }
}
