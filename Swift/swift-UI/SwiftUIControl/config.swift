//
//  config.swift
//  SwiftUIControl
//
//  Created by zidon on 15/5/7.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

import UIKit

class config: NSObject {
//    override init() {
        let IS_IOS7:Bool = (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 7.0
        let IS_IOS8:Bool = (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8.0
//    }
}
/*

#ifdef DEBUG
# define YYLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define YYLog(...)
#endif

*/
