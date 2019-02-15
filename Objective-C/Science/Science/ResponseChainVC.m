//
//  ResponseChainVC.m
//  Science
//
//  Created by zidonj on 2018/11/26.
//  Copyright © 2018 langlib. All rights reserved.
//

#import "ResponseChainVC.h"

@interface ResponseChainVC ()

@end

@implementation ResponseChainVC

#pragma mark -- cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uiConfig];
}

#pragma mark -- UIConfig

- (void)uiConfig {

    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)sddd:(id)sender {
    
    NSLog(@"点击了屏幕按钮");
}

#pragma mark -- Public Method

#pragma mark -- Private Method

#pragma mark - Action

#pragma mark - KVO

#pragma mark - noticfication

#pragma mark -- Protocols

#pragma mark -- UITableViewDelegate

#pragma mark -- UITableViewDataSource


#pragma mark -- Setters

#pragma mark -- Getters


- (void)dealloc {
    NSLog(@"%@-释放",[self class]);
}

@end

@implementation UIBaseView


@end


@implementation UIView1

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self _config];
    }
    return self;
}


- (void)_config {
        
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test:)];
    [self addGestureRecognizer:tap];
}

- (void)test:(UITapGestureRecognizer *)tap {
    
    NSLog(@"%@",NSStringFromClass(tap.view.class));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"Blue");
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    NSLog(@"命中测试:Blue");
    return [super hitTest:point withEvent:event];
}

@end


@implementation UIView2

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _config];
    }
    return self;
}

- (void)_config {

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test:)];
    [self addGestureRecognizer:tap];
}

- (void)test:(UITapGestureRecognizer *)tap {
    
    NSLog(@"%@",NSStringFromClass(tap.view.class));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"Red");
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    NSLog(@"命中测试:Red");
    return [super hitTest:point withEvent:event];
}

@end


@implementation UIView3

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _config];
    }
    return self;
}
- (void)_config {
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test:)];
//    [self addGestureRecognizer:tap];
}

- (void)test:(UITapGestureRecognizer *)tap {
    
    NSLog(@"%@",NSStringFromClass(tap.view.class));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"Green");
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    NSLog(@"命中测试:Green");
    return [super hitTest:point withEvent:event];
}

@end
