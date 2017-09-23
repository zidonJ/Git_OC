//
//  UIViewController+Helper.m
//  ZidonRunTime
//
//  Created by 姜泽东 on 2017/9/11.
//  Copyright © 2017年 姜泽东. All rights reserved.
//

#import "UIViewController+Helper.h"
#import <objc/runtime.h>

#pragma mark Class Definition

@implementation UIViewController (Helper)


+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(mt_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)mt_viewWillAppear:(BOOL)animated
{
    [self mt_viewWillAppear:animated];
    NSLog(@"这是一段经典的旋律");
}

#pragma mark - Properties


#pragma mark - Public Methods



@end
