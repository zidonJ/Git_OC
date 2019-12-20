//
//  PViewController.m
//  QMUIKit_Study
//
//  Created by zidonj on 2019/11/25.
//  Copyright © 2019 zidonj. All rights reserved.
//

#import "PViewController.h"
#import <QMUIKit/QMUIKit.h>

@interface PViewController () <QMUINavigationControllerAppearanceDelegate>

@end

@implementation PViewController

#pragma mark -- cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self uiConfig];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

//MARK:  -- UIConfig

- (void)uiConfig {

    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self layoutContrains];
}

//MARK:  -- Public Method

//MARK:  -- Private Method

//MARK:  - Action

//MARK:  - KVO

//MARK:  - noticfication

//MARK:  -- Protocols 三方｜自定义 代理｜协议

#pragma mark - QMUINavigationControllerDelegate

- (UIImage *)navigationBarBackgroundImage {
    return [UIImage qmui_imageWithColor:[UIColor redColor]];
}

- (nullable UIColor *)navigationBarBarTintColor {
    return [UIColor redColor];
}

- (UIImage *)navigationBarShadowImage {
    return NavBarShadowImage;
}

- (UIColor *)navigationBarTintColor {
    return NavBarBarTintColor;
    return [UIColor redColor];
}

- (UIColor *)titleViewTintColor {
    return NavBarTitleColor;
}

#pragma mark - <QMUICustomNavigationBarTransitionDelegate>

- (NSString *)customNavigationBarTransitionKey {
    return @"bvbvbvb";
}

//MARK:  -- UITableViewDelegate

//MARK:  -- UITableViewDataSource

//MARK:  -- http request

//MARK:  -- layoutContrains masonry布局代码
- (void)layoutContrains {
    
    
}

//MARK:  -- Setters

//MARK:  -- Getters


- (void)dealloc {
    NSLog(@"%@-释放",[self class]);
}



@end
