//
//  RAC_StudyTests.m
//  RAC_StudyTests
//
//  Created by zidonj on 2019/11/24.
//  Copyright © 2019 zidonj. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface RAC_StudyTests : XCTestCase

@end

@implementation RAC_StudyTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}
// 创建信号 并 订阅 流程
- (void)testFlow {
    //1、创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"多次订阅 是否执行多次lalalalalalallal");
        //任何时候，都可以发送信号，可以异步
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendNext:@3];
        [subscriber sendNext:@4];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"回收");
        }];
    }];
    
    
    RACSignal *signalTestSubScribe = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return nil;
    }];
    
    /*
     其函数签名可以理解为 id -> RACSignal，然而这种函数是无法直接对 RACSignal 对象进行变换的；
     不过通过 -bind: 方法就可以使用这种函数操作 RACSignal，其实现如下：
     
     将 RACSignal 对象『解包』出 NSObject 对象；
     将 NSObject 传入 RACSignalBindBlock 返回 RACSignal。
     */
    RACSignal *bindSignal = [signal bind:^RACSignalBindBlock _Nonnull{
        return ^(NSNumber *value, BOOL *stop) {
            value = @(value.integerValue * value.integerValue);
            return [RACSignal return:value];
        };
    }];
    
    RACSignal *bindSignal1 = [signal bind:^RACSignalBindBlock _Nonnull{
        return ^(NSNumber *value, BOOL *stop) {
            NSNumber *returnValue = @(value.integerValue * value.integerValue);
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                for (NSInteger i = 0; i < value.integerValue; i++) {
                    [subscriber sendNext:returnValue];
                    [subscriber sendCompleted];
                }
                return nil;
            }];
        };
    }];
    
    //2、订阅信号
    
    [signalTestSubScribe subscribeNext:^(id  _Nullable x) {
        NSLog(@"signalTestSubScribe:%@",x);
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"oneSignal: %@", x);
    }];
    
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"oneSignal: %@", x);
    }];
    
    [bindSignal1 subscribeNext:^(id  _Nullable x) {
        NSLog(@"bindSignal1: %@", x);
    }];
}

// 避免订阅过多时 多次执行block回调
- (void)test_onceExecution {
    //1、创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"多次订阅 是否执行多次lalalalalalallal");
        //任何时候，都可以发送信号，可以异步
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *oneSignal = [signal replayLazily]; // 避免多次执行  使用RACMulticastConnection实现

    RACSignal *bindSignal = [oneSignal bind:^RACSignalBindBlock _Nonnull{
        return ^(NSNumber *value, BOOL *stop) {
            value = @(value.integerValue * value.integerValue);
            return [RACSignal return:value];
        };
    }];
    //2、订阅信号
    [oneSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"oneSignal: %@", x);
    }];
    
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"oneSignal: %@", x);
    }];
    
    // 避免多次执行的代码
    RACMulticastConnection *connection = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"多次订阅 是否执行多次");
        //任何时候，都可以发送信号，可以异步
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendNext:@3];
        [subscriber sendNext:@4];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"回收");
        }];
    }] publish];

    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"signal: %@", x);
    }];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"signal1: %@", x);
    }];
    
    [connection connect];

    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"bindSignal: %@", x);
    }];
}

- (void)testRACReplaySubject1 {
    /// 设置接受事件的数量为2
    RACReplaySubject *replaySubject = [RACReplaySubject replaySubjectWithCapacity:2];
    
    [replaySubject sendNext:@"hello world"]; //这句打印会被移除，原因是因为前面设置了接收事件的数量为2
    [replaySubject sendNext:@"rac"];
    [replaySubject sendNext:@"text 3"];
    
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者接收到的数据%@",x);
    }];
    
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者接收到的数据%@",x);
    }];

}

- (void)testRACReplaySubject2 {
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"多次订阅 是否执行多次lalalalalalallal111");
        //任何时候，都可以发送信号，可以异步
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendCompleted];
        return nil;
    }] replayLazily] ;
    
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"测试重复执行:%@",x);
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"测试重复执行:%@",x);
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"测试重复执行:%@",x);
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
