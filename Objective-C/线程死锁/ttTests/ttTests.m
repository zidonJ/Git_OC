//
//  ttTests.m
//  ttTests
//
//  Created by 姜泽东 on 2017/8/30.
//  Copyright © 2017年 姜泽东. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ttTests : XCTestCase

@end

@implementation ttTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}


- (void)test1 {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //任务1
        for (int i = 0; i < 2; i++) {
            NSLog(@"我是任务一、来自线程：%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //任务2
        for (int i = 0; i < 2 ; i++) {
            NSLog(@"我是任务二、来自线程：%@",[NSThread currentThread]);
        }
    });
    
    
    dispatch_barrier_async(queue, ^{
        //栅栏
        for (int i = 0; i < 1 ; i++) {
            NSLog(@"我是分割线、来自线程：%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        //任务3
        for (int i = 0; i < 1 ; i++) {
            NSLog(@"我是任务三、来自线程：%@",[NSThread currentThread]);
        }
    });

}

- (void)test2 {
    NSLog(@"开始啦");
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //任务1
        for (int i = 0; i < 2; i++) {
            NSLog(@"我是任务一、来自线程：%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //任务2
        for (int i = 0; i < 2 ; i++) {
            NSLog(@"我是任务二、来自线程：%@",[NSThread currentThread]);
        }
    });
    
      NSLog(@"动啊动啊");
    dispatch_barrier_async(queue, ^{
        //珊栏
        for (int i = 0; i < 1 ; i++) {
            NSLog(@"我是分割线、来自线程：%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        //任务3
        for (int i = 0; i < 1 ; i++) {
            NSLog(@"我是任务三、来自线程：%@",[NSThread currentThread]);
        }
    });
    NSLog(@"结束啦");

}

- (void)test3 {
    NSLog(@"开始啦");
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //任务1
        for (int i = 0; i < 2; i++) {
            NSLog(@"我是任务一、来自线程：%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //任务2
        for (int i = 0; i < 2 ; i++) {
            NSLog(@"我是任务二、来自线程：%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"动次打次：%@",[NSThread currentThread]);
    dispatch_barrier_sync(queue, ^{
        //珊栏
        for (int i = 0; i < 1 ; i++) {
            NSLog(@"我是分割线、来自线程：%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        //任务3
        for (int i = 0; i < 1 ; i++) {
            NSLog(@"我是任务三、来自线程：%@",[NSThread currentThread]);
        }
    });
    NSLog(@"结束啦");

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
