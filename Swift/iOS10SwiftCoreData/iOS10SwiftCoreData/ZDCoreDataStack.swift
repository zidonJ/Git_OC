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
    
    lazy var context:NSManagedObjectContext={
        [weak self] in
        return self!.recordStack.context
    }()
    
    init(dataName:String,storeType:String) {
        super.init()
        recordStack.dataName=dataName
        recordStack.storeType=storeType
    }
}

extension ZDCoreDataStack{
    func saveData(paramter:Dictionary<String, Any>, enity:NSManagedObject) -> Bool {
        //kvc
        enity.setValuesForKeys(paramter)
        do {
            try self.recordStack.context.save()
        } catch _ {
            print("存储失败",#line)
        }
        return true
    }
    
    func deleteData(enity:NSManagedObject) -> Bool {
        self.context.delete(enity)
        do {
            try self.context.save()
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
