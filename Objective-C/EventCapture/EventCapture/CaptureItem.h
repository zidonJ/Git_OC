//
//  CaptureItem.h
//  EventCapture
//
//  Created by zidon on 16/8/17.
//  Copyright © 2016年 zidon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaptureItem : NSObject

//触发的哪个事件
@property (nonatomic,copy) NSString *eventId;
//用户
@property (nonatomic,copy) NSString *userId;
//时间戳
@property (nonatomic,copy) NSString *timereavl;
//点击的频率,需要本地存储
@property (nonatomic,copy) NSString *clickCount;

@end
