//
//  RWViewController.m
//  RWReactivePlayground
//
//  Created by Colin Eberhardt on 18/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "RWViewController.h"
#import "RWDummySignInService.h"
#import "ReactiveCocoa.h"


@interface RWViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureText;

@property (strong, nonatomic) RWDummySignInService *signInService;

@end

@implementation RWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.signInService = [RWDummySignInService new];
    
    // initially hide the failure message
    self.signInFailureText.hidden = YES;
    
    //    [self.usernameTextField.rac_textSignal subscribeNext:^(id x){
    //        NSLog(@"%@", x);
    //    }];
    
    //    [[self.usernameTextField.rac_textSignal filter:^BOOL(id value) {
    //        NSString*text = value;
    //        return text.length > 3;
    //    }] subscribeNext:^(id x) {
    //        NSLog(@"%@",x);
    //    }];
    
    
    //map 返回监听的数据类型，filter对接收到的数据进行过滤，获取接收到的数据
    [[[self.usernameTextField.rac_textSignal
       map:^id(NSString *text){
           return text;
       }]filter:^BOOL(NSString *length){
           return length.length > 3;
       }]subscribeNext:^(id x){
           NSLog(@"%@", x);
       }];
    
    
    RACSignal *validUsernameSignal =
    [self.usernameTextField.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidUsername:text]);
     }];
    RACSignal *validPasswordSignal =
    [self.passwordTextField.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidPassword:text]);
     }];
    
    RAC(self.passwordTextField, backgroundColor) =
    [validPasswordSignal
     map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
     }];
    
    RAC(self.usernameTextField, backgroundColor) =
    [validUsernameSignal
     map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
     }];
    
    RACSignal *signUpActiveSignal =
    [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal]
                      reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
                          return @([usernameValid boolValue]&&[passwordValid boolValue]);
                      }];
    
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive){
        self.signInButton.enabled =[signupActive boolValue];
    }];
    
    
    [[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside]
      flattenMap:^id(id x){
          return[self signInSignal];
      }] subscribeNext:^(id x){
          NSLog(@"Sign in result: %@", x);
      }];
    
}

- (RACSignal *)signInSignal {
    
    return [RACSignal createSignal:^RACDisposable *(id subscriber){
        [self.signInService
         signInWithUsername:self.usernameTextField.text
         password:self.passwordTextField.text
         complete:^(BOOL success){
             [subscriber sendNext:@(success)];
             [subscriber sendCompleted];
         }];
        return nil;
    }];
}

- (BOOL)isValidUsername:(NSString *)username {
    return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 3;
}

- (IBAction)signInButtonTouched:(id)sender {
    // disable all UI controls
    self.signInButton.enabled = NO;
    self.signInFailureText.hidden = YES;
    
    // sign in
    [self.signInService signInWithUsername:self.usernameTextField.text
                                  password:self.passwordTextField.text
                                  complete:^(BOOL success) {
                                      self.signInButton.enabled = YES;
                                      self.signInFailureText.hidden = success;
                                      if (success) {
                                          [self performSegueWithIdentifier:@"signInSuccess" sender:self];
                                      }
                                  }];
}

@end
