//
//  QNCountDown.m
//  XXT
//
//  Created by zidon on 15/7/28.
//  Copyright (c) 2015年 北京青牛科技有限公司. All rights reserved.
//

#import "QNCountTimer.h"

@interface QNCountTimer ()

{
    SEL _selt;
    id _target;
    timeBlock _timeRollBack;
    NSTimer *_timer;
    BOOL _timerBeginControl;
}

@end

@implementation QNCountTimer

+(id)sharedInstance
{
    static QNCountTimer *timer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timer=[[QNCountTimer alloc] init];
    });
    return timer;
}

static dispatch_source_t _timer;
static UIButton *btnTemp;
static dispatch_queue_t queue;

-(void)timeControl:(timeBlock)timeRollBack
{
    _timeRollBack=[timeRollBack copy];
    _timer=[[NSTimer alloc] initWithFireDate:[NSDate distantPast] interval:3 target:self selector:@selector(timeControll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)suspend
{
    _timerBeginControl=YES;
    [_timer setFireDate:[NSDate distantFuture]];
}

-(void)resume
{
    _timerBeginControl=NO;
    [_timer setFireDate:[NSDate distantPast]];
}

-(void)timeControll
{
    if (!_timerBeginControl) {
        _timerBeginControl=YES;
        return;
    }
    _timeRollBack();
}

+(void)myInitialize
{
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
}

+(void)makeAnSingleTime:(float)time withTriggerBlock:(void(^)(void))trigger
{
    [self myInitialize];
    dispatch_source_set_timer(_timer,dispatch_time(DISPATCH_TIME_NOW, time*NSEC_PER_SEC),3*NSEC_PER_SEC, 1);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            trigger();
        });
    });
    dispatch_resume(_timer);
}

+(void)timeViewShow:(UIButton *)timeView
{
    [self myInitialize];
    __block int timeout=60; //倒计时时间
    btnTemp=timeView;
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [timeView setTitle:@"发送验证码" forState:UIControlStateNormal];
                timeView.userInteractionEnabled = YES;
                dispatch_source_cancel(_timer);//结束资源管理
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [timeView setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                timeView.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

+(void)stop
{
    dispatch_source_cancel(_timer);//结束资源管理
}


@end
