//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by zidonj on 2017/1/10.
//  Copyright © 2017年 zidon. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,copy) NSString *str;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [RACObserve(self, str) subscribeNext:^(id  _Nullable x) {
        NSLog(@"->%@",x);
    }];
    
    
    [[RACObserve(self, str) filter:^BOOL(id  _Nullable value) {
        NSLog(@"::%@",value);
        return YES;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"--:%@",x);
    }];
    
    [RACObserve(self, imgView.image) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [RACObserve(self, textField.text) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    @weakify(self);
    [self.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"-->:%@_%@",self_weak_.textField.text,x);
    }];
    
//    RAC(self.button, enabled) = [RACSignal combineLatest:@[self.textField.rac_textSignal,]
//                                                  reduce:^(NSString *username, NSString *password, NSNumber *loggingIn, NSNumber *loggedIn) {
//        return @(username.length > 0);
//    }];
    
    
//    RAC(self.button, enabled) 
    
    [RACSignal combineLatest:@[self.textField.rac_textSignal] reduce:^id _Nullable{
        return nil;
    }];
    
    RACSignal *validUsernameSignal = [self.usernameTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidUsername:text]);
    }];
    
    RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidPassword:text]);
    }];
    
    //    [[validPasswordSignal map:^id(NSNumber *passwordValid){
    //        return [passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
    //    }] subscribeNext:^(UIColor *color){
    //         self.passwordTextField.backgroundColor = color;
    //    }];
    
    RAC(self.passwordTextField, backgroundColor) = [validPasswordSignal map:^id(NSNumber *passwordValid){
        return [passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
    }];
    
    RAC(self.usernameTextField, backgroundColor) = [validUsernameSignal map:^id(NSNumber *passwordValid){
        return [passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
    }];
    
    RACSignal *signUpActiveSignal =
    [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal]
                      reduce:^id (NSNumber*usernameValid, NSNumber *passwordValid){
                          return @([usernameValid boolValue]&&[passwordValid boolValue]);
                      }];
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
        self.signInButton.enabled =[signupActive boolValue];
    }];
    
    [[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"button clicked");
    }];
    
}

- (IBAction)click:(id)sender {
    //_str赋值不会调用RACObserve
    self.str=@"if you";
    self.imgView.image=[UIImage imageNamed:@"11"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
