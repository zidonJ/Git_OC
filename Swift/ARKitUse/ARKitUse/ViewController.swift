//
//  ViewController.swift
//  ARKitUse
//
//  Created by 姜泽东 on 2017/9/19.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

import UIKit




class ViewController: UIViewController {

    //下标的使用
    struct TimesTable {
        let multiplier: Int
        subscript(index: Int) -> Int {
            return multiplier * index
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let threeTimesTable = TimesTable(multiplier: 3)
        print("six times three is \(threeTimesTable[6])")
    }




}

