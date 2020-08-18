//
//  ViewController.m
//  EventCapture
//
//  Created by zidon on 16/8/17.
//  Copyright © 2016年 zidon. All rights reserved.
//

#import "ViewController.h"
#import "RunloopEventCapture.h"

@interface ViewController ()<RunloopEventCaptureDelegate>
{
    RunloopEventCapture *_runloop;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.］
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(10, 20, 100, 30);
    btn.backgroundColor=[UIColor redColor];
    [btn setTitle:@"source" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jojo1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    _runloop=[RunloopEventCapture sharedRunLoopWorkDistribution];
    _runloop.delegate=self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self jojo1];
    });
    
}

- (void)jojo1 {
    
    [_runloop addTask:^BOOL{
        return YES;
    } withKey:@"lala"];
    
    
}

//这个过程是异步的，注意操作UI的时候要回到主线程
-(void)testUploadCaptureUserData:(NSString *)key
{
    NSLog(@":::%@",key);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"lalala");
}


@end
