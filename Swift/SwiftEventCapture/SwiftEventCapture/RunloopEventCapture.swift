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
    @objc optional func asyncUploadCaptureUserData(data:AnyObject) -> Bool
}

typealias MyRunLoopWorkDistributionUnit = (Bool) -> Void

class RunloopEventCapture: NSObject {
    
    var captureObjct:AnyObject?
    
    override init() {
        super.init()
        resgistRunloopWork(obj: self)
    }
    
    static let sharedInstace=RunloopEventCapture()
    
    /**
     添加单个事件对象监听,在事件的触发处调用这个方法
     
     - parameter key:  回调的block
     - parameter unit: 唯一的key值
     */
    func addTask(key:AnyObject) {
        
        captureObjct=key
        
        //可以设置最大的任务数量
        if self.taskContent.count > self.maxTasks {
            self.taskContent.removeAll()
        }
    }
    
    /**
     添加多个事件对象的监听,在事件的触发处调用这个方法
     
     - parameter keys: key的数组
     */
    func addKeysTask(keys:NSArray) {
        self.taskContent=keys as Array<AnyObject>
    }
    
    /**
     添加多个事件对象的监听,在事件的触发处调用这个方法
     
     - parameter items: 模型的数组
     */
    func addItemsTask(items:NSArray) {
        self.taskContent=items as [AnyObject]
    }
    
    var maxTasks=30
    var taskContent:Array=[AnyObject]()
    var delegate:RunloopEventCaptureDelegate?
    
    func resgistRunloopWork(obj:RunloopEventCapture) {
        
        self.registerObserver(activities: CFRunLoopActivity.beforeWaiting.rawValue, order: INTMAX_MAX-999, mode: CFRunLoopMode.defaultMode , info: unsafeBitCast(obj, to: UnsafeMutableRawPointer.self)) { (runLoopObsver, activity, info) in
            
            RunloopEventCapture.sharedInstace.runLoopWorkDistributionCallback(observer: runLoopObsver!, activity: activity, info: info!)
        }
        
    }
    
    func runLoopWorkDistributionCallback(observer:CFRunLoopObserver , activity:CFRunLoopActivity , info:UnsafeRawPointer) {
        
        //print(":::",printActivity(activity));
        
        if (self.taskContent.count == 0) {
            return;
        }
        
        var result:Bool? = false
        while (result == false && self.taskContent.count != 0) {
            //保证我们需要的截获事件之执行一次
            if self.captureObjct == nil {
                break
            }
            
            let isContained:Bool=self.taskContent.contains(where: { (Obj) -> Bool in
                
                if Obj.isEqual(self.captureObjct){
                    return true
                }
                
                return false
            })
        
            if (isContained) {
                
                weak var weakSelf:RunloopEventCapture!=self
                DispatchQueue.global().async {
                    result=weakSelf.delegate?.asyncUploadCaptureUserData!(data: weakSelf.captureObjct!)
                    DispatchQueue.main.async {
                        self.captureObjct=nil
                    }
                }
                
                
                break
            }
        }
    }
    
    func registerObserver(activities:CFOptionFlags, order:CFIndex, mode:CFRunLoopMode, info:UnsafeMutableRawPointer, callback:@escaping CFRunLoopObserverCallBack ) {
        let runLoop:CFRunLoop=CFRunLoopGetCurrent()
        var context:CFRunLoopObserverContext=CFRunLoopObserverContext.init(version: 0, info: unsafeBitCast(self, to: UnsafeMutableRawPointer.self), retain: nil, release: nil, copyDescription: nil)
        let observer:CFRunLoopObserver=CFRunLoopObserverCreate(nil, activities, true, order, callback, &context)
//        RunLoop
        CFRunLoopAddObserver(runLoop, observer, mode)
    }
    
    //runloop的状态变化
    func printActivity(activity:CFRunLoopActivity) ->String{
        var activityDescription:String=""
        switch (activity) {
        case CFRunLoopActivity.entry:
            activityDescription = "kCFRunLoopEntry"
            break;
        case CFRunLoopActivity.beforeTimers:
            activityDescription = "kCFRunLoopBeforeTimers"
            break;
        case CFRunLoopActivity.beforeSources:
            activityDescription = "kCFRunLoopBeforeSources"
            break;
        case CFRunLoopActivity.beforeWaiting:
            activityDescription = "kCFRunLoopBeforeWaiting"
            break;
        case CFRunLoopActivity.afterWaiting:
            activityDescription = "kCFRunLoopAfterWaiting"
            break;
        case CFRunLoopActivity.exit:
            activityDescription = "kCFRunLoopExit"
            break;
        default:
            break;
            
        }
        return activityDescription
    }
    
}
