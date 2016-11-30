//
//  CoreDataConifgration.swift
//  iOS10SwiftCoreData
//
//  Created by zidonj on 2016/11/30.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit
import CoreData

class CoreDataConifgration: NSObject {

    //生成单利
    static let instance:CoreDataConifgration=CoreDataConifgration()
    
    var dataName:String?=nil
    var storeType:String?=nil
    
    //model
    lazy var coreDataModel:NSManagedObjectModel = {
        [weak self] in
        let bundle:Bundle=Bundle.init(for:CoreDataConifgration.self)
        let url:URL=bundle.url(forResource: self?.dataName, withExtension: "momd")!
        let model=NSManagedObjectModel.init(contentsOf: url)
        return model!
    }()
    
    //psc
    lazy var psc:NSPersistentStoreCoordinator={
        [weak self] in
        //版本迁移
        let configuration=[NSInferMappingModelAutomaticallyOption:true,NSMigratePersistentStoresAutomaticallyOption:true]
        let tmPsc:NSPersistentStoreCoordinator=NSPersistentStoreCoordinator.init(managedObjectModel: (self?.coreDataModel)!)
        
        try! tmPsc.addPersistentStore(ofType: (self?.storeType!)!, configurationName: nil, at: self?.storeUrl(), options: nil)
        return tmPsc
    }()
    //context
    lazy var context:NSManagedObjectContext={
        [weak self] in
        let ctxBackGround=NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        ctxBackGround.persistentStoreCoordinator=self?.psc;
        let mainContext=NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        mainContext.parent=ctxBackGround
        return mainContext
    }()
    
    func storeUrl() -> URL {
        let fileManager=FileManager.default
        let coreDataFileUrl:URL = try! fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
        return coreDataFileUrl
    }
    
}
