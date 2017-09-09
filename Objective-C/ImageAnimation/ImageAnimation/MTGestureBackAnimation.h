//
//  MTGestureBackAnimation.m
//  ImageAnimation
//
//  Created by 姜泽东 on 2017/9/6.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Enumerations


typedef NS_ENUM(NSInteger, GestureBackType) {
    PanDown,
    PinchSmall,
};

typedef NS_ENUM(NSInteger, InteractiveAnimationType) {
    AnimationTypeGo,
    AnimationTypeBack,
};

@interface MTGestureBackAnimation : NSObject<UIViewControllerAnimatedTransitioning,UIViewControllerInteractiveTransitioning,UIViewControllerTransitioningDelegate>

#pragma mark -- Properties

@property (nonatomic, assign, getter = isInteractive) BOOL interactive;

#pragma mark -- public func --

#pragma mark -- init
- (instancetype)initWithController:(UIViewController *)viewController;

- (void)setInteractiveViewController:(UIViewController *)viewController;

- (void)setGestureBackType:(GestureBackType)type;
- (void)setInteractiveType:(InteractiveAnimationType)type;

@end
