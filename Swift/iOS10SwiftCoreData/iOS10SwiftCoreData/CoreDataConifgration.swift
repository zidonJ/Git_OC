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
    
    //psc配置自动版本迁移,适配新的模型
    public static var stockSQLiteStoreOptions: [AnyHashable: Any] {
        //            NSSQLitePragmasOption: ["journal_mode": "WAL"]
        return [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: false,
        ]
    }
    
    //Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Person")
        container.loadPersistentStores(completionHandler: { [weak self](storeDescription, error) in
            if let error = error {
                
            }
        })
        return container
    }()
    
    //model
    lazy var coreDataModel:NSManagedObjectModel = {
        [weak self] in
        let bundle:Bundle=Bundle.init(for:CoreDataConifgration.self)
        let url:URL=bundle.url(forResource: self?.dataName, withExtension: "momd")!
        let model=NSManagedObjectModel.init(contentsOf: url)
        return model!
    }()
    
    //psc
    lazy var psc:NSPersistentStoreCoordinator = {
        [weak self] in
        //版本迁移 addPersistentStore的最后一个参数options
        let configuration=[NSInferMappingModelAutomaticallyOption:true,
                           NSMigratePersistentStoresAutomaticallyOption:true]
        let tmPsc:NSPersistentStoreCoordinator=NSPersistentStoreCoordinator.init(managedObjectModel: (self?.coreDataModel)!)
        //(self?.storeType!)!
        let storeUrl:URL=(self?.storeUrl().appendingPathComponent("swiftCoreData.sqlite"))!
        
        var persistentStore: NSPersistentStore?
        var error: NSError?
        do {
            persistentStore=try tmPsc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: stockSQLiteStoreOptions)
            
        }catch let _error as NSError {
            error = _error
        }
        return tmPsc
    }()
    //context
    lazy var context:NSManagedObjectContext={
        [weak self] in
        //write moc
        let ctxBackGround=NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        ctxBackGround.persistentStoreCoordinator=self?.psc;
        //main moc
        let mainContext=NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        mainContext.parent=ctxBackGround
        return mainContext
    }()
    
    func storeUrl() -> URL {
        let fileManager=FileManager.default
        let coreDataFileUrl:URL = try! fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
        print(coreDataFileUrl)
        return coreDataFileUrl
    }
    
}
