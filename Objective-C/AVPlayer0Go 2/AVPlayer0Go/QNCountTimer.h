//
//  QNCountDown.h
//  XXT
//
//  Created by zidon on 15/7/28.
//  Copyright (c) 2015年 北京青牛科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^timeBlock)(void);

@interface QNCountTimer : NSObject

//倒计时
+(void)timeViewShow:(UIButton *)timeView;
//停止
+(void)stop;
//暂停
-(void)suspend;
//继续
-(void)resume;
//定时器
+(void)makeAnSingleTime:(float)time withTriggerBlock:(void(^)(void))trigger;

+(id)sharedInstance;
-(void)timeControl:(timeBlock)timeRollBack;

@end
