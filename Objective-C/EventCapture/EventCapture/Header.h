//
//  MyRunLoop.m
//  EventCapture
//
//  Created by zidon on 16/8/17.
//  Copyright © 2016年 zidon. All rights reserved.
//

#import "MyRunLoop.h"

@interface MyRunLoop ()

@property (nonatomic, strong) NSMutableArray *tasks;

@property (nonatomic, strong) NSMutableArray *tasksKeys;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MyRunLoop

- (void)addTask:(MyRunLoopWorkDistributionUnit)unit withKey:(id)key{
    [self.tasks addObject:unit];
    [self.tasksKeys addObject:key];
    if (self.tasks.count > self.maxiTasks) {
        [self.tasks removeObjectAtIndex:0];
        [self.tasksKeys removeObjectAtIndex:0];
    }
}

- (instancetype)init
{
    if ((self = [super init])) {
        //_maximumQueueLength = 30;
        _tasks = [NSMutableArray array];
        _tasksKeys = [NSMutableArray array];
        //        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(_timerFiredMethod:) userInfo:nil repeats:YES];
    }
    return self;
}

+ (instancetype)sharedRunLoopWorkDistribution {
    static MyRunLoop *singleton;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singleton = [[MyRunLoop alloc] init];
        [self _registerRunLoopWorkDistributionAsMainRunloopObserver:singleton];
    });
    return singleton;
}

+ (void)_registerRunLoopWorkDistributionAsMainRunloopObserver:(MyRunLoop *)runLoopWorkDistribution {
    
    NSThread *thd=[[NSThread alloc] initWithTarget:self selector:@selector(_registerRunLoopWorkDistributionAsMainRunloopObserver1:) object:runLoopWorkDistribution];
    [thd start];
}

+ (void)_registerRunLoopWorkDistributionAsMainRunloopObserver1:(MyRunLoop *)runLoopWorkDistribution
{
    [[NSRunLoop currentRunLoop] run];
    static CFRunLoopObserverRef defaultModeObserver;
    _registerObserver(kCFRunLoopBeforeWaiting, defaultModeObserver, NSIntegerMax - 999, kCFRunLoopDefaultMode, (__bridge void *)runLoopWorkDistribution, &_defaultModeRunLoopWorkDistributionCallback);
}


static void _defaultModeRunLoopWorkDistributionCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    _runLoopWorkDistributionCallback(observer, activity, info);
}

static void _runLoopWorkDistributionCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    //    MyRunLoop *runLoopWorkDistribution = (__bridge MyRunLoop *)info;
    
    NSLog(@":::%@",printActivity(activity));
    
    //    if (runLoopWorkDistribution.tasks.count == 0) {
    //        return;
    //    }
    //    BOOL result = NO;
    //    while (result == NO && runLoopWorkDistribution.tasks.count) {
    //        MyRunLoopWorkDistributionUnit unit  = runLoopWorkDistribution.tasks.firstObject;
    //        result = unit();
    //        [runLoopWorkDistribution.tasks removeObjectAtIndex:0];
    //        [runLoopWorkDistribution.tasksKeys removeObjectAtIndex:0];
    //    }
}

static inline NSString* printActivity(CFRunLoopActivity activity)
{
    NSString *activityDescription;
    switch (activity) {
        case kCFRunLoopEntry:
            activityDescription = @"kCFRunLoopEntry";
            break;
        case kCFRunLoopBeforeTimers:
            activityDescription = @"kCFRunLoopBeforeTimers";
            break;
        case kCFRunLoopBeforeSources:
            activityDescription = @"kCFRunLoopBeforeSources";
            break;
        case kCFRunLoopBeforeWaiting:
            activityDescription = @"kCFRunLoopBeforeWaiting";
            break;
        case kCFRunLoopAfterWaiting:
            activityDescription = @"kCFRunLoopAfterWaiting";
            break;
        case kCFRunLoopExit:
            activityDescription = @"kCFRunLoopExit";
            break;
        default:
            break;
            
    }
    return activityDescription;
}

static void _registerObserver(CFOptionFlags activities, CFRunLoopObserverRef observer, CFIndex order, CFStringRef mode, void *info, CFRunLoopObserverCallBack callback) {
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopObserverContext context = {
        0,
        info,
        &CFRetain,
        &CFRelease,
        NULL
    };
    observer = CFRunLoopObserverCreate(     NULL,
                                       activities,
                                       YES,
                                       order,
                                       callback,
                                       &context);
    CFRunLoopAddObserver(runLoop, observer, mode);
    CFRelease(observer);
}

@end
