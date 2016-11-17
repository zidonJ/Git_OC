//
//  ZDCoreDataStack.swift
//  iOS10SwiftCoreData
//
//  Created by zidonj on 2016/11/9.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit
import CoreData

class HTMLElement {
    
    let name: String
    let text: String?
    
    
    
    lazy var asHTML: () -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
    
}

class ZDCoreDataStack: NSObject {
    //生成单利
    static let coreDataStack:ZDCoreDataStack=ZDCoreDataStack()

    var dataName:String?=nil
    
    lazy var coreDataModel:NSManagedObjectModel = {
        [weak self] in
        let bundle:Bundle=Bundle.init(for:objc_getClass(unsafeBitCast(self, to: UnsafePointer.self)) as! AnyClass)
        let url:URL=bundle.url(forResource: self?.dataName, withExtension: "momd")!
        let model=NSManagedObjectModel.init(contentsOf: url)
        return model!
    }()
    
    
    lazy var psc:NSPersistentStoreCoordinator={
        [weak self] in
        let configuration=[NSInferMappingModelAutomaticallyOption:true,NSMigratePersistentStoresAutomaticallyOption:true]
        let tmPsc=NSPersistentStoreCoordinator.init(managedObjectModel: (self?.coreDataModel)!)
        return tmPsc
    }()
    
    
}
