//
//  MyWorkerClass.m
//  NSPort
//
//  Created by 姜泽东 on 2018/2/22.
//  Copyright © 2018年 MaiTian. All rights reserved.
//

#import "MyWorkerClass.h"

@interface MyWorkerClass() <NSMachPortDelegate> {
    
    NSPort *remotePort;
    NSPort *myPort;
}
@end

#define kMsg1 100
#define kMsg2 101

@implementation MyWorkerClass

- (void)launchThreadWithPort:(NSPort *)port {
    
    @autoreleasepool {
        
        //1. 保存主线程传入的port
        remotePort = port;
        
        //2. 设置子线程名字
        [[NSThread currentThread] setName:@"MyWorkerClassThread"];
        
        //4. 创建自己port
        myPort = [NSMachPort port];
        
        //5.
        myPort.delegate = self;
        
        //7. 完成向主线程port发送消息
        [self sendPortMessage];
        //6. 将自己的port添加到runloop
        //作用1、防止runloop执行完毕之后推出
        //作用2、接收主线程发送过来的port消息
        [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
        
        [NSRunLoop.currentRunLoop run];
    }
}

/**
 *   完成向主线程发送port消息
 */
- (void)sendPortMessage {
    
    //发送消息到主线程，操作1
    [remotePort sendBeforeDate:[NSDate date]
                         msgid:kMsg1
                    components:[@[[@"hello" dataUsingEncoding:NSUTF8StringEncoding]] mutableCopy]
                          from:myPort
                      reserved:0];
    
    //发送消息到主线程，操作2
    //    [remotePort sendBeforeDate:[NSDate date]
    //                         msgid:kMsg2
    //                    components:nil
    //                          from:myPort
    //                      reserved:0];
}


#pragma mark - NSPortDelegate

/**
 *  接收到主线程port消息
 */
- (void)handlePortMessage:(NSPortMessage *)message {
    
    NSLog(@"接收到父线程的消息...\n");
    
    //    unsigned int msgid = [message msgid];
    //    NSPort* distantPort = nil;
    //
    //    if (msgid == kCheckinMessage)
    //    {
    //        distantPort = [message sendPort];
    //
    //    }
    //    else if(msgid == kExitMessage)
    //    {
    //        CFRunLoopStop((__bridge CFRunLoopRef)[NSRunLoop currentRunLoop]);
    //    }
}


static CFDataRef Callback(CFMessagePortRef port,SInt32 messageID,CFDataRef data,void *info) {
    return NULL;
}

- (void)test {
    
    CFMessagePortRef localPort =
    CFMessagePortCreateLocal(nil,CFSTR("com.example.app.port.server"),Callback,nil,nil);
    
    CFRunLoopSourceRef runLoopSource =
    CFMessagePortCreateRunLoopSource(nil, localPort, 0);
    
    CFRunLoopAddSource(CFRunLoopGetCurrent(),
                       runLoopSource,
                       kCFRunLoopCommonModes);
    
    CFDataRef data;
    SInt32 messageID = 0x1111; // Arbitrary
    CFTimeInterval timeout = 10.0;
    
    CFMessagePortRef remotePort =
    CFMessagePortCreateRemote(nil,CFSTR("com.example.app.port.client"));
    
    SInt32 status =
    CFMessagePortSendRequest(remotePort,
                             messageID,
                             data,
                             timeout,
                             timeout,
                             NULL,
                             NULL);
    if (status == kCFMessagePortSuccess) {
        
    }
}

@end
