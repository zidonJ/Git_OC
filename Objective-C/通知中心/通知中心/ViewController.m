//
//  ViewController.m
//  通知中心
//
//  Created by zidonj on 2020/7/30.
//  Copyright © 2020 zidonj. All rights reserved.
//

#import "ViewController.h"

@interface MyThreadedClass: NSObject <NSMachPortDelegate>
/* Threaded notification support. */
@property NSMutableArray *notifications;
@property NSThread *notificationThread;
@property NSLock *notificationLock;
@property NSMachPort *notificationPort;

- (void)setUpThreadingSupport;
- (void)handleMachMessage:(void *)msg;
- (void)processNotification:(NSNotification *)notification;
@end

@implementation MyThreadedClass

- (void)setUpThreadingSupport {
    if (self.notifications) {
        return;
    }
    self.notifications      = [[NSMutableArray alloc] init];
    self.notificationLock   = [[NSLock alloc] init];
    self.notificationThread = [NSThread currentThread];
    
    self.notificationPort = [[NSMachPort alloc] init];
    [self.notificationPort setDelegate:self];
    [[NSRunLoop currentRunLoop] addPort:self.notificationPort
                                forMode:NSRunLoopCommonModes];
}

- (void)handleMachMessage:(void *)msg {
    
    [self.notificationLock lock];
    
    while ([self.notifications count]) {
        NSNotification *notification = [self.notifications objectAtIndex:0];
        [self.notifications removeObjectAtIndex:0];
        [self.notificationLock unlock];
        [self processNotification:notification];
        [self.notificationLock lock];
    };
    
    [self.notificationLock unlock];
}

- (void)processNotification:(NSNotification *)notification {
    
    if ([NSThread currentThread] != _notificationThread) {
        // Forward the notification to the correct thread.
        [self.notificationLock lock];
        [self.notifications addObject:notification];
        [self.notificationLock unlock];
        [self.notificationPort sendBeforeDate:[NSDate date]
                                   components:nil
                                         from:nil
                                     reserved:0];
    }
    else {
        // Process the notification here;
    }
}

@end

@interface ViewController ()

@property (nonatomic, strong) MyThreadedClass *mt;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mt = MyThreadedClass.new;
    [self.mt setUpThreadingSupport];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(processNotification:)
                                                 name:@"NotificationName"
                                               object:nil];
}


@end
