//
//  ViewController.swift
//  SwiftEventCapture
//
//  Created by zidon on 16/8/17.
//  Copyright © 2016年 zidon. All rights reserved.
//

import UIKit

class ViewController: UIViewController , RunloopEventCaptureDelegate {

    var eventCapture:RunloopEventCapture=RunloopEventCapture.sharedInstace
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        let btn:UIButton=UIButton.init(type: UIButtonType.Custom)
        btn.frame=CGRect(x: 10, y: 20, width: 100, height: 30)
        btn.backgroundColor=UIColor.redColor()
        btn.setTitle("测试哈", forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(self.testRunloopCapture(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
                
        eventCapture.delegate=self
    }
    
    func testUploadCaptureUserData(key: String) -> Bool {
        print("上传的用户数据",":",key)
        return true
    }
    
    func asyncUploadCaptureUserData(item: NSObject) -> Bool {
        return true
    }
    
    func testRunloopCapture(btn:UIButton) {
        
        eventCapture.addTask("那一种寸步不离的感觉，我知道就叫做永远")
        
        print("这是一段经典的旋律")
    }
}

