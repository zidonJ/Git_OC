//
//  config.swift
//  SwiftUIControl
//
//  Created by zidon on 15/5/7.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

import UIKit

class config: NSObject {
    let IS_IOS7:Bool = (UIDevice.current.systemVersion as NSString).doubleValue >= 7.0
    let IS_IOS8:Bool = (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0
}
