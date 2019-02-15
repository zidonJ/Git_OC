//
//  LoopCapture.m
//  Science
//
//  Created by zidonj on 2018/11/7.
//  Copyright © 2018 langlib. All rights reserved.
//

#import "LoopCapture.h"

/*
 1. kCFRunLoopDefaultMode: App的默认 Mode，通常主线程是在这个 Mode 下运行的。
 2. UITrackingRunLoopMode: 界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响。
 3. UIInitializationRunLoopMode: 在刚启动 App 时第进入的第一个 Mode，启动完成后就不再使用。
 4: GSEventReceiveRunLoopMode: 接受系统事件的内部 Mode，通常用不到。
 5: kCFRunLoopCommonModes: 这是一个占位的 Mode，没有实际作用。
 */

@interface LoopCapture () {
    
    int timeoutCount;
    CFRunLoopObserverRef observer;
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity activity;
}

@end

@implementation LoopCapture

#pragma mark --public

+ (instancetype)sharedRunLoopWorkDistribution {
    static LoopCapture *singleton;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singleton = [[LoopCapture alloc] init];
    });
    return singleton;
}

- (void)start {
    
    [self _registerRunLoopWorkDistributionAsMainRunloopObserver];
}

- (void)stop {
    
    if (!observer) {
        return;
    }
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
    observer = NULL;
}

#pragma mark --private func
- (void)_registerRunLoopWorkDistributionAsMainRunloopObserver {
    
    [self _registerObserver:kCFRunLoopAllActivities
                   observer:observer
                      order:0
                       mode:kCFRunLoopCommonModes
                       info:(__bridge void *)self
                   callback:&_defaultModeRunLoopWorkDistributionCallback];
}

static void _defaultModeRunLoopWorkDistributionCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    _runLoopWorkDistributionCallback(observer, activity, info);
}

///监听到的回调
static void _runLoopWorkDistributionCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    
    LoopCapture *runLoopWorkDistribution = (__bridge LoopCapture *)info;
    runLoopWorkDistribution->activity = activity;
    dispatch_semaphore_t semaphore = runLoopWorkDistribution->semaphore;
    dispatch_semaphore_signal(semaphore);
    
    //该参数配置观察者监听Run Loop的哪种运行状态
    switch (activity) {
        case kCFRunLoopEntry:
            break;
        case kCFRunLoopBeforeTimers:
            break;
        case kCFRunLoopBeforeSources:
            break;
        case kCFRunLoopBeforeWaiting:
            break;
        case kCFRunLoopAfterWaiting:
            break;
        case kCFRunLoopExit:
            break;
        default:
            break;
    }
    
}

///用这种方式做卡顿分析不能够完全准确,腾讯的bugly采用的策略是将这种方式与CPU运行的时钟频率结合作为标准做卡顿分析
- (void)_registerObserver:(CFOptionFlags)activities observer:(CFRunLoopObserverRef)sendObserver order:(CFIndex)order mode:(CFStringRef)mode info:(void *)info callback:(CFRunLoopObserverCallBack)callback {
    
    if (observer) {
        return;
    }
    
    CFRunLoopObserverContext context = {0,info,NULL,NULL,NULL};
    
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,//对象内存分配器
                                       activities,
                                       YES,//标识观察者只监听一次还是每次Run Loop运行时都监听
                                       order,//观察者优先级，当Run Loop中有多个观察者监听同一个运行状态时，那么就根据该优先级判断，0为最高优先级别
                                       callback,//观察者的回调函数
                                       &context);//观察者的上下文
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, mode);

    // 信号
    semaphore = dispatch_semaphore_create(0);
    
    // 假定连续5次超时50ms认为卡顿
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            //Returns zero on success, or non-zero if the timeout occurred.
            long st = dispatch_semaphore_wait(self->semaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));
            if (st != 0) {
                if (!self->observer) {
                    self->timeoutCount = 0;
                    self->semaphore = 0;
                    self->activity = 0;
                    return;
                }
                if (self->activity == kCFRunLoopBeforeSources || self->activity == kCFRunLoopAfterWaiting) {
                    NSLog(@"%d",self->timeoutCount);
                    if (++self->timeoutCount < 5)
                        continue;
                    NSLog(@"卡顿了");
                }
            }
            self->timeoutCount = 0;
        }
    });
}

@end
