//
//  PViewController.m
//  QMUIKit_Study
//
//  Created by zidonj on 2019/11/25.
//  Copyright © 2019 zidonj. All rights reserved.
//

#import "PViewController.h"
#import <QMUIKit/QMUIKit.h>

@interface UIViewController (bar) <QMUINavigationControllerDelegate>


@end

@implementation UIViewController (bar)
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
}

- (UIColor *)titleViewTintColor {
    return NavBarTitleColor;
}
@end

@interface UINavigationBar (mb)

@end

@implementation UINavigationBar (mb)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        ExtendImplementationOfVoidMethodWithTwoArguments([UINavigationBar class], @selector(setBackgroundImage:forBarMetrics:), UIImage *, UIBarMetrics, ^(UINavigationBar *selfObject, UIImage *backgroundImage, UIBarMetrics barMetrics) {
            [selfObject.standardAppearance setBackgroundImage:backgroundImage];
        });
        
        ExtendImplementationOfVoidMethodWithSingleArgument([UINavigationBar class], @selector(setShadowImage:), UIImage *, ^(UINavigationBar *selfObject, UIImage *firstArgv) {
            [selfObject.standardAppearance setShadowImage:firstArgv];
        });
    });
}

@end

@interface PViewController ()

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
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//}

- (NavBarType)currentNavBarType {
    return BrainmanBlueColor;
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

#pragma mark - <QMUICustomNavigationBarTransitionDelegate>

- (NSString *)customNavigationBarTransitionKey {
    return @"456";
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
