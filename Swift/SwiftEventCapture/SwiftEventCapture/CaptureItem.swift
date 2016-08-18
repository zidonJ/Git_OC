//
//  CaptureItem.swift
//  SwiftEventCapture
//
//  Created by zidon on 16/8/17.
//  Copyright © 2016年 zidon. All rights reserved.
//

import Foundation

class CaptureItem: NSObject {
    //触发哪个事件
    var eventId:String?
    //用户
    var userId:String?
    //事件触发时的时间戳
    var timereavl:String?
    //点击的频率（需要存入本地数据）
    var clickCount:String?
}
