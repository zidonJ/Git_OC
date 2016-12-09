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
    
    lazy var writeContext:NSManagedObjectContext={
        [weak self] in
        return self!.recordStack.context
    }()
    
    lazy var mainContext:NSManagedObjectContext={
        [weak self] in
        return self!.recordStack.context.parent
    }()!
    
    init(dataName:String,storeType:String) {
        super.init()
        recordStack.dataName=dataName
        recordStack.storeType=storeType
    }
    //负责通知parent,parent会知道这些改变.
    func childContext() -> NSManagedObjectContext {
        let childMoc=NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        childMoc.parent=self.mainContext
        return childMoc
    }
}

extension ZDCoreDataStack{
    func saveData(paramter:Dictionary<String, Any>, enity:NSManagedObject) -> Bool {
        //child moc
        let childMoc=self.childContext()
        //kvc
        enity.setValuesForKeys(paramter)
        
        childMoc.perform({
            do {
                try childMoc.save()
            } catch _{
                print("存储失败",#line)
            }
            
            do {
                try self.mainContext.save()
            } catch _{
                print("存储失败",#line)
            }
            
            do {
                try self.writeContext.save()
            } catch _{
                print("存储失败",#line)
            }
        })
        
        return true
    }
    
    func deleteData(enity:NSManagedObject) -> Bool {
        self.writeContext.delete(enity)
        do {
            try self.writeContext.save()
        } catch _ {
            print("删除错误",#line)
        }
        return true
    }
    
    func updateData() -> Bool {
        return true
    }
    
    /// 查询数据
    ///
    /// - Parameters:
    ///   - enity: 实体名字
    ///   - ascendBy: 依赖什么进行排序
    ///   - ascending: 升序降序
    /// - Returns: 查询到的数据数组
    func fetchData(enity:String, ascendBy:String, ascending:Bool) -> Array<Any>?{
        return self.makeFetchRequest(enity: enity, ascendBy: ascendBy, ascending: ascending)
    }
    
    /// 创建列表数据关联类
    ///
    /// - Parameters:
    ///   - enity: 实体名字
    ///   - ascendBy: 依赖什么排序
    ///   - ascending: 升序降序
    ///   - section: 依赖什么分组
    ///   - cache: 是否使用缓存
    /// - Returns: 返回NSFetchedResultsController
    func fetchData(enity:String, ascendBy:String, ascending:Bool, name section:String, name cache:String) -> NSFetchedResultsController<NSFetchRequestResult> {
        let request=NSFetchRequest<NSFetchRequestResult>(entityName: enity)
        request.sortDescriptors=[NSSortDescriptor.init(key: ascendBy, ascending: ascending)]
        let fetchVc:NSFetchedResultsController=NSFetchedResultsController.init(fetchRequest: request, managedObjectContext: self.recordStack.context, sectionNameKeyPath: section, cacheName: cache)
        do {
            try fetchVc.performFetch()
        } catch _ {
            print("错误",#line)
        }
        return fetchVc
    }
    
    private func makeFetchRequest(enity:String, ascendBy:String, ascending:Bool) -> Array<Any>?{
        let request=NSFetchRequest<NSFetchRequestResult>(entityName: enity)
        request.sortDescriptors=[NSSortDescriptor.init(key: ascendBy, ascending: ascending)]
        var fetchContent:Array<Any>?=nil
        do {
            fetchContent = try self.recordStack.context.fetch(request)
        } catch _ {
            print("查询错误",#line)
        }
        return fetchContent
    }
}
