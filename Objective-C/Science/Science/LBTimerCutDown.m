//
//  LBTimerCutDown.m
//  TOEFL
//
//  Created by zidonj on 2019/1/26.
//  Copyright © 2019 Langlib. All rights reserved.
//

#import "LBTimerCutDown.h"

@interface LBTimerCutDown ()

@property (nonatomic,strong) dispatch_source_t timer;
@property (nonatomic,strong) dispatch_queue_t queue;
@property (nonatomic,weak)  id target;

@end

@implementation LBTimerCutDown

+ (instancetype)shareInstance {
    
    static LBTimerCutDown *cutDown = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cutDown = [[LBTimerCutDown alloc] init];
    });
    return cutDown;
}

- (void)shareCountDown:(NSInteger (^)(void))downSec sec:(void (^)(NSInteger))secCall complete:(BOOL (^)(void))downComplete withTarget:(id)target {
    
    self.target = target;
    [self shareCountDown:downSec sec:secCall complete:downComplete];
}

- (void)shareCountDown:(NSInteger (^ _Nonnull )(void))downSec
                   sec:(void (^ _Nullable)(NSInteger sec))secCall
              complete:(BOOL (^ _Nullable) (void))downComplete {
    
    [self stopTimerCutDown];
    __block NSInteger count = downSec();
    dispatch_source_set_timer(self.timer,DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC, 0);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        __strong typeof(weakSelf) self = weakSelf;
        if (!self || !self.target) {
            dispatch_source_cancel(self.timer);
            return ;
        }
        
        if (count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !secCall?:secCall(count);
                count--;
            });
            
        }else if (count <= 0){
            
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (downComplete && self.timer) {
                    BOOL repeat = downComplete();
                    if (repeat) {
                        [self shareCountDown:downSec sec:secCall complete:downComplete];
                    }
                }
            });
        }
        
    });
    dispatch_resume(self.timer);
}

- (void)stopTimerCutDown {
    
    if (_timer) {
        dispatch_source_cancel(_timer);
//        self.timer = nil;
//        self.queue = nil;
    }
}

#pragma mark -- getters

- (dispatch_source_t)timer {
    
    if (!_timer) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
    }
    return _timer;
}

- (dispatch_queue_t)queue {
    
    if (!_queue) {
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return _queue;
}

@end
