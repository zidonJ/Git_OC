//
//  RunloopEventCapture.swift
//  SwiftEventCapture
//
//  Created by zidon on 16/8/17.
//  Copyright © 2016年 zidon. All rights reserved.
//

import Foundation

@objc protocol RunloopEventCaptureDelegate {
    //返回值代表继续执行事件（已经添加的事件）
    optional func testUploadCaptureUserData(key:String) -> Bool
    
    optional func asyncUploadCaptureUserData(item:NSObject) -> Bool
}

typealias MyRunLoopWorkDistributionUnit = (Bool) -> Void

class RunloopEventCapture: NSObject {
    /**
     添加单个事件对象监听,在事件的触发处调用这个方法
     
     - parameter key:  回调的block
     - parameter unit: 唯一的key值
     */
    func addTask(key:String) {
        
        self.taskContent.append(key)
        if self.taskContent.count > self.maxTasks {
            self.taskContent.removeAll()
        }
    }
    
    /**
     添加多个事件对象的监听,在事件的触发处调用这个方法
     
     - parameter keys: key的数组
     */
    func addKeysTask(keys:NSArray) {
        
    }
    
    /**
     添加多个事件对象的监听,在事件的触发处调用这个方法
     
     - parameter items: 模型的数组
     */
    func addItemsTask(items:NSArray) {
        
    }
    
    var maxTasks=30
    var taskContent:Array<AnyObject>=[AnyObject]()
    var delegate:RunloopEventCaptureDelegate?
    
    
    
    override init() {
        super.init()
        resgistRunloopWork(self)
    }
    
    static let sharedInstace=RunloopEventCapture()
    
    
    func resgistRunloopWork(obj:RunloopEventCapture) {
        
        self.registerObserver(CFRunLoopActivity.BeforeWaiting.rawValue, order: INTMAX_MAX-999, mode: kCFRunLoopDefaultMode, info: unsafeBitCast(obj, UnsafeMutablePointer<Void>.self)) { (runLoopObsver, activity, info) in
            
            RunloopEventCapture.sharedInstace.runLoopWorkDistributionCallback(runLoopObsver, activity: activity, info: info)
        }
        
    }
    
    func runLoopWorkDistributionCallback(observer:CFRunLoopObserverRef , activity:CFRunLoopActivity , info:UnsafePointer<Void>) {
        
        print(":::",printActivity(activity));
        
        if (self.taskContent.count == 0) {
            return;
        }
        
        var result:Bool = false
        while (result == false && self.taskContent.count != 0) {
            
            if (self.taskContent[0] as! String == "那一种寸步不离的感觉，我知道就叫做永远") {
                
                print("对头，要的就是你")
                weak var weakSelf=self
                dispatch_async(dispatch_get_global_queue(0, 0), { 
                    result=(weakSelf?.delegate?.testUploadCaptureUserData!("那一种寸步不离的感觉，我知道就叫做永远"))!
                })
            }
            self.taskContent.removeAtIndex(0)
        }
    }
    
    func printActivity(activity:CFRunLoopActivity) ->String{
        var activityDescription:String=""
        switch (activity) {
            case CFRunLoopActivity.Entry:
                activityDescription = "kCFRunLoopEntry"
                break;
            case CFRunLoopActivity.BeforeTimers:
                activityDescription = "kCFRunLoopBeforeTimers"
                break;
            case CFRunLoopActivity.BeforeSources:
                activityDescription = "kCFRunLoopBeforeSources"
                break;
            case CFRunLoopActivity.BeforeWaiting:
                activityDescription = "kCFRunLoopBeforeWaiting"
                break;
            case CFRunLoopActivity.AfterWaiting:
                activityDescription = "kCFRunLoopAfterWaiting"
                break;
            case CFRunLoopActivity.Exit:
                activityDescription = "kCFRunLoopExit"
                break;
            default:
                break;
            
        }
        return activityDescription
    }
    
    func registerObserver(activities:CFOptionFlags, order:CFIndex, mode:CFStringRef, info:UnsafeMutablePointer<Void>, callback:CFRunLoopObserverCallBack ) {
        let runLoop:CFRunLoop=CFRunLoopGetCurrent()
        var context:CFRunLoopObserverContext=CFRunLoopObserverContext.init(version: 0, info: unsafeBitCast(self, UnsafeMutablePointer<Void>.self), retain: nil, release: nil, copyDescription: nil)
        let observer:CFRunLoopObserver=CFRunLoopObserverCreate(nil, activities, true, order, callback, &context)
        
        CFRunLoopAddObserver(runLoop, observer, mode)
    }
}
