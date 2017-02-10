//
//  NBPointer.swift
//  SwiftUIControl
//
//  Created by zidonj on 2017/1/19.
//  Copyright © 2017年 zidon. All rights reserved.
//

import UIKit

class NBPointer: NSObject {

    override init() {
        //声明一个可变指针类型的数组
        let unsafemutablepointer : UnsafeMutablePointer<Int>
        unsafemutablepointer = UnsafeMutablePointer.allocate(capacity: 3)
        unsafemutablepointer[0] = 1
        unsafemutablepointer[1] = 2
        unsafemutablepointer[2] = 3
        
        var intArray : Array<Int> = [1,2,3]
        intArray[1] = 3
    }
    
}
