//
//  ViewController.swift
//  贝塞尔曲线
//
//  Created by zidon on 16/4/6.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var berthV:berthView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        berthV=berthView.init(frame:CGRectMake(100,100,250,250))
        berthV?.backgroundColor=UIColor.brownColor()
        self.view.addSubview(berthV!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

