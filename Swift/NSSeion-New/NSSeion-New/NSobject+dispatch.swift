//
//  NSobject+dispatch.swift
//  NSSeion-New
//
//  Created by zidon on 16/6/20.
//  Copyright © 2016年 zidon. All rights reserved.
//

import Foundation

typealias asyncDoClose = ()->()

extension NSObject{
    
    struct MyFirsStruct {
        
    }
    
    //异步执行
    func asyncDo(asDo:asyncDoClose) {
        let dispatch:DispatchQueue=DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault)
        dispatch.async { 
            asDo()
        }
    }
    //弱引用
    func weakMe(swiftObj:AnyObject) -> AnyObject {
        weak var obj=swiftObj
        return obj!
    }
}



