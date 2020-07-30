//
//  ViewController.swift
//  Bolts_study
//
//  Created by zidonj on 2020/6/3.
//  Copyright © 2020 zidonj. All rights reserved.
//

import UIKit
import Bolts

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.getNumberAsync().continueWith { (task: BFTask!) -> Any? in
            print(":::::",task.result!)
        }
    }
    
    func getStringAsync() -> BFTask<AnyObject> {
        //Let's suppose getNumberAsync returns a BFTask whose result is an NSNumber.
        return self.getNumberAsync().continueWith {
            (task: BFTask!) -> NSString in
            
            let number = task.result
            return NSString(format:"%@", number as! NSNumber)
        }
    }
    
    func getNumberAsync() -> BFTask<AnyObject> {
        let bft = BFTaskCompletionSource<AnyObject>()
        bft.set(result: NSNumber(value: 8.8))
        return bft.task
    }
}

