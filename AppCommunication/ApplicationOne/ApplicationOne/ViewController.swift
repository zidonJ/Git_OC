//
//  ViewController.swift
//  ApplicationOne
//
//  Created by jiaweibai on 15/9/15.
//  Copyright (c) 2015年 GarveyCalvin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func openApplication() {
        
        
        let pasteboard = UIPasteboard.general
        pasteboard.string="这是一段经典的旋律"
        
        let urlSting = "GC://GarveyCalvin&GCFirst111"
        if let url = URL(string: urlSting) {
            let application = UIApplication.shared
            if application.canOpenURL(url) {
                application.openURL(url)
            }
        }
    }

}
