//
//  ViewController.m
//  NSPort
//
//  Created by 姜泽东 on 2018/2/22.
//  Copyright © 2018年 MaiTian. All rights reserved.
//

#define kMsg1 100
#define kMsg2 101

#import "ViewController.h"
#import "MyWorkerClass.h"

@interface ViewController ()<NSPortDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1. 创建主线程的port
    //子线程通过此端口发送消息给主线程
    NSPort *myPort = [NSMachPort port];
    
    //2. 设置port的代理回调对象
    myPort.delegate = self;
    
    //3. 把port加入runloop,接收port消息
    [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
    
    NSLog(@"---myport %@", myPort);
    //4. 启动次线程,并传入主线程的port
    MyWorkerClass *work = [[MyWorkerClass alloc] init];
    [NSThread detachNewThreadSelector:@selector(launchThreadWithPort:)
                             toTarget:work
                           withObject:myPort];
}

- (void)handlePortMessage:(NSMessagePort *)message {
    
    NSLog(@"接到子线程传递的消息！%@",message);
    
    //1. 消息id
    NSUInteger msgId = [[message valueForKeyPath:@"msgid"] integerValue];
    
    //2. 当前主线程的port
    NSPort *localPort = [message valueForKeyPath:@"localPort"];
    
    //3. 接收到消息的port（来自其他线程）
    NSPort *remotePort = [message valueForKeyPath:@"remotePort"];
    
    if (msgId == kMsg1) {
        //向子线的port发送消息
        [remotePort sendBeforeDate:[NSDate date]
                             msgid:kMsg2
                        components:nil
                              from:localPort
                          reserved:0];
        
    } else if (msgId == kMsg2){
        NSLog(@"操作2....\n");
    }
}

@end
