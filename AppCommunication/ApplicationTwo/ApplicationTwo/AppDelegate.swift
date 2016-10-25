//
//  AppDelegate.swift
//  ApplicationTwo
//
//  Created by jiaweibai on 15/9/15.
//  Copyright (c) 2015年 GarveyCalvin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        
        let pasteboard = UIPasteboard.general
        print("11111",pasteboard.string)
        let newUrlHost = url.absoluteString 
        jump(newUrlHost as NSString)
        
        return false
    }
    
    func jump(_ urlHost: NSString) {
        // Alert params
        let range = urlHost.range(of: "//")
    
        var alertView: UIAlertView
        if range.length != NSNotFound {
            let params = urlHost.substring(from: range.length + range.location)
            alertView = UIAlertView(title: "params is \(params) \n and Returns automatically after 3 seconds", message: nil, delegate: nil, cancelButtonTitle: "Confirm")
            alertView.show()
        } else {
            alertView = UIAlertView(title: "haven't params", message: nil, delegate: nil, cancelButtonTitle: "Confirm")
            alertView.show()
        }
        
        // Reverse
        let protocolFromAppRange = urlHost.range(of: "&")
        if protocolFromAppRange.length != NSNotFound {
            let protocolUrl = urlHost.substring(from: protocolFromAppRange.length + protocolFromAppRange.location)
            
            // Timer
            let time = 3.0
            let delay = DispatchTime.now() + Double(Int64(UInt64(time) * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) { () -> Void in
                alertView.dismiss(withClickedButtonIndex: 0, animated: true)
                
                let urlSting = "\(protocolUrl)://"
                if let url = URL(string: urlSting) {
                    let application = UIApplication.shared
                    if application.canOpenURL(url) {
                        application.openURL(url)
                    }
                }
            }
        }
    }

    


}

