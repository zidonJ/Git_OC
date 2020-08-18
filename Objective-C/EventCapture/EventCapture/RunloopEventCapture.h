//
//  MyRunLoop.h
//  EventCapture
//
//  Created by zidon on 16/8/17.
//  Copyright © 2016年 zidon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CaptureItem.h"

@protocol RunloopEventCaptureDelegate <NSObject>

@optional

-(void)testUploadCaptureUserData:(NSString *)key;

-(void)asyncUploadCaptureUserData:(CaptureItem *)item;

@end

typedef BOOL(^MyRunLoopWorkDistributionUnit)(void);

@interface RunloopEventCapture : NSObject

void inception_runloop();

+ (instancetype)sharedRunLoopWorkDistribution;

- (void)addTask:(MyRunLoopWorkDistributionUnit)unit withKey:(id)key;


@property (nonatomic,assign) NSInteger maxiTasks;

@property (nonatomic,strong) NSThread *thd;

@property (nonatomic,weak) id<RunloopEventCaptureDelegate> delegate;

@end
