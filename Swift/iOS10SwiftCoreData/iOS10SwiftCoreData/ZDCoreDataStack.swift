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
    
    init(dataName:String,storeType:String) {
        super.init()
        CoreDataConifgration.instance.dataName=dataName
        CoreDataConifgration.instance.storeType=storeType
    }
    
    
}

extension ZDCoreDataStack{
    func insert(paramter:Dictionary<String, Any>) -> Bool {
        return true
    }
}
