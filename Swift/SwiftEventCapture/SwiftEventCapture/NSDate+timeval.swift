//
//  NSDate+timeval.swift
//  SwiftEventCapture
//
//  Created by zidon on 16/8/18.
//  Copyright © 2016年 zidon. All rights reserved.
//

import Foundation


extension NSDate{
    
    class func getTimestamp() -> String {
        //获取当前时间
        let now = NSDate()
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        print("当前日期时间：\(dformatter.string(from: now as Date))")
        //当前时间的时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        print("当前时间的时间戳：\(timeStamp)")
        return String(timeStamp)
    }
    
    class func formateTime(timeStamp:Int) -> String {
        //时间戳
        let timeStamp = 1463637809
        print("时间戳：\(timeStamp)")
        
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        
        //格式话输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        print("对应的日期时间：\(dformatter.string(from: date as Date))")
        return dformatter.string(from: date as Date)
    }
}
