//
//  MyRunLoop.m
//  EventCapture
//
//  Created by zidon on 16/8/17.
//  Copyright © 2016年 zidon. All rights reserved.
//

#import "RunloopEventCapture.h"
#import <dlfcn.h>
#import "fishhook.h"

@interface RunloopEventCapture ()

@property (nonatomic, strong) NSMutableArray *tasks;

@property (nonatomic, strong) NSMutableArray *tasksKeys;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RunloopEventCapture
/**
 *  添加单个事件对象监听
 *
 *  @param unit 回调block
 *  @param key  唯一key值
 */
- (void)addTask:(MyRunLoopWorkDistributionUnit)unit withKey:(id)key{
    [self.tasks addObject:unit];
    [self.tasksKeys addObject:key];
    if (self.tasks.count > self.maxiTasks) {
        [self.tasks removeObjectAtIndex:0];
        [self.tasksKeys removeObjectAtIndex:0];
    }
}
/**
 *  同时添加多个事件监听对象
 *
 *  @param keys key值的数组
 */
- (void)addTaskWithKeys:(NSArray *)keys {
    [self.tasksKeys addObjectsFromArray:keys];
    if (self.tasks.count > self.maxiTasks) {
        [self.tasks removeObjectAtIndex:0];
        [self.tasksKeys removeObjectAtIndex:0];
    }
}
/**
 *  同时添加多个事件监听对象
 *
 *  @param items 模型的数组
 */
- (void)addTaskWithItems:(NSArray *)items {
    
    [self.tasksKeys addObjectsFromArray:items];
    if (self.tasks.count > self.maxiTasks) {
        [self.tasks removeObjectAtIndex:0];
        [self.tasksKeys removeObjectAtIndex:0];
    }
}

- (instancetype)init {
    
    if ((self = [super init])) {
        _maxiTasks = 30;
        _tasks = [NSMutableArray array];
        _tasksKeys = [NSMutableArray array];
        //_timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(_timerFiredMethod:) userInfo:nil repeats:YES];
    }
    return self;
}

+ (instancetype)sharedRunLoopWorkDistribution {
    static RunloopEventCapture *singleton;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singleton = [[RunloopEventCapture alloc] init];
        [self _registerRunLoopWorkDistributionAsMainRunloopObserver:singleton];
    });
    return singleton;
}

+ (void)_registerRunLoopWorkDistributionAsMainRunloopObserver:(RunloopEventCapture *)runLoopWorkDistribution {
    static CFRunLoopObserverRef defaultModeObserver;
    //_defaultModeRunLoopWorkDistributionCallback 方法地址
    _registerObserver(kCFRunLoopBeforeWaiting, defaultModeObserver, NSIntegerMax - 999, kCFRunLoopDefaultMode, (__bridge void *)runLoopWorkDistribution, &_defaultModeRunLoopWorkDistributionCallback);
}

//监听里存了方法的地址_defaultModeRunLoopWorkDistributionCallback
static void _defaultModeRunLoopWorkDistributionCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    _runLoopWorkDistributionCallback(observer, activity, info);
}

static void _runLoopWorkDistributionCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    
    RunloopEventCapture *runLoopWorkDistribution = (__bridge RunloopEventCapture *)info;
    
    NSLog(@":::%@",printActivity(activity));
    
    if (runLoopWorkDistribution.tasks.count == 0) {
        return;
    }
    BOOL result = NO;
    while (result == NO && runLoopWorkDistribution.tasks.count) {
        MyRunLoopWorkDistributionUnit unit  = runLoopWorkDistribution.tasks.firstObject;
        if ([runLoopWorkDistribution.tasksKeys[0] isEqualToString:@"lala"]) {
            
            if (runLoopWorkDistribution.delegate&&[runLoopWorkDistribution.delegate respondsToSelector:@selector(testUploadCaptureUserData:)]) {
                /**
                 *  需要埋点的记录，异步上传
                 */
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [runLoopWorkDistribution.delegate testUploadCaptureUserData:@"对头，要的就是你"];
                });
            }
        }
        result = unit();
        [runLoopWorkDistribution.tasks removeObjectAtIndex:0];
        [runLoopWorkDistribution.tasksKeys removeObjectAtIndex:0];
    }
}

static inline NSString *printActivity(CFRunLoopActivity activity) {
    
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
    observer = CFRunLoopObserverCreate(NULL,
                                       activities,
                                       YES,
                                       order,
                                       callback,
                                       &context);
    
    CFRunLoopAddObserver(runLoop, observer, mode);
    CFRelease(observer);
}

static void (*orig_CFRunLoopAddObserver)(CFRunLoopRef, CFRunLoopObserverRef, CFRunLoopMode);
void my_CFRunLoopAddObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFRunLoopMode mode) {
    NSLog(@"\n---------:Calling CFRunLoopAddObserver(runloop(%p), %@, %@)\n\n",
          rl,
          observer,
          mode);
    orig_CFRunLoopAddObserver(rl, observer, mode);
}

static struct rebinding rebindings[] = {
    { "CFRunLoopAddObserver",
        my_CFRunLoopAddObserver,
        (void *)&orig_CFRunLoopAddObserver },
};

void inception_runloop() {
    rebind_symbols(rebindings, sizeof(rebindings)/sizeof(struct rebinding));
}

@end
