//
//  ZDBaseNavigationController.m
//  QMUIKit_Study
//
//  Created by zidonj on 2020/8/17.
//  Copyright © 2020 zidonj. All rights reserved.
//

#import "ZDBaseNavigationController.h"
#import <ReactiveObjC.h>

@interface ZDBaseNavigationController () <UINavigationControllerDelegate>

@end

@implementation ZDBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self)
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self_weak_;
        self.delegate = self_weak_;
    }

}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if ([self.topViewController respondsToSelector:@selector(willPop)]) {
    }
    return [super popViewControllerAnimated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self.topViewController respondsToSelector:@selector(willPop)]) {
    }
    return [super popToViewController:viewController animated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    if ([self.topViewController respondsToSelector:@selector(willPop)]) {
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count < 2) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }else {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    if(gestureRecognizer == self.interactivePopGestureRecognizer && self.viewControllers.count < 2) {
         return NO;
    }
    return YES;
}


@end
