//
//  JavaScriptCoreVC.swift
//  WebCallNative
//
//  Created by zidonj on 2018/11/21.
//  Copyright © 2018 langlib. All rights reserved.
//

import UIKit
import JavaScriptCore

class JavaScriptCoreVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        hello()
    }

    func hello() {
        
        //创建虚拟机
        let jsvm = JSVirtualMachine()
        //创建上下文
        guard let ctx = JSContext(virtualMachine: jsvm) else {
            return
        }
        //执行JavaScript代码并获取返回值
        let value = ctx.evaluateScript("1+2*3");
        //转换成OC数据并打印
        print(value?.toInt32() ?? "value为空")
    }
}
