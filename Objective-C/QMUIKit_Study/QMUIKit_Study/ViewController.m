//
//  ViewController.m
//  QMUIKit_Study
//
//  Created by zidonj on 2019/11/24.
//  Copyright © 2019 zidonj. All rights reserved.
//

#import "ViewController.h"
#import <QMUIKit/QMUIKit.h>
#import "PViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//}

- (IBAction)test:(id)sender {
    PViewController *pv = PViewController.new;
    pv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pv animated:YES];
}

#pragma mark - QMUINavigationControllerDelegate

- (UIImage *)navigationBarBackgroundImage {
    return [UIImage qmui_imageWithColor:[UIColor greenColor]];
}

- (nullable UIColor *)navigationBarBarTintColor {
    return [UIColor greenColor];
}

- (UIImage *)navigationBarShadowImage {
    return [UIImage qmui_imageWithColor:[UIColor blueColor]];;
}

- (UIColor *)navigationBarTintColor {
    return NavBarTintColor;
}

- (UIColor *)titleViewTintColor {
    return NavBarTitleColor;
}

#pragma mark - <QMUICustomNavigationBarTransitionDelegate>

- (NSString *)customNavigationBarTransitionKey {
    return @"123";
}


@end
