//
//  ViewController.swift
//  iOS10SwiftCoreData
//
//  Created by zidonj on 2016/10/27.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    let coreDataConfig:ZDCoreDataStack=ZDCoreDataStack.init(dataName: "swift 3.0 ios 10", storeType: NSSQLiteStoreType)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }



}

