//
//  LBTimerCutDown.h
//  TOEFL
//
//  Created by zidonj on 2019/1/26.
//  Copyright © 2019 Langlib. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LBTimerCutDown : NSObject

+ (instancetype)shareInstance;

/**
 倒计时
 
 @param downSec 倒计时duration
 @param secCall 回调
 @param downComplete 倒计时完成
 */
- (void)shareCountDown:(NSInteger (^ _Nonnull )(void))downSec
                   sec:(void (^ _Nullable)(NSInteger sec))secCall
              complete:(BOOL (^ _Nullable) (void))downComplete;

/**
 倒计时 弱引用对象
 
 @param downSec 倒计时duration
 @param secCall 回调
 @param downComplete 倒计时完成
 @param target 在哪里被引用
 */
- (void)shareCountDown:(NSInteger (^ _Nonnull )(void))downSec
                   sec:(void (^ _Nullable)(NSInteger sec))secCall
              complete:(BOOL (^ _Nullable) (void))downComplete
            withTarget:(id)target;

- (void)stopTimerCutDown;

@end

NS_ASSUME_NONNULL_END
