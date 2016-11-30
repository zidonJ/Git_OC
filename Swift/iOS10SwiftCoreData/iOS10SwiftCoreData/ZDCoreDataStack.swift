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
    
    init(dataName:String,storeType:String) {
        super.init()
        recordStack.dataName=dataName
        recordStack.storeType=storeType
    }
    
    
}

extension ZDCoreDataStack{
    func saveData(paramter:Dictionary<String, Any>) -> Bool {
        return true
    }
}
