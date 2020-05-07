//
//  RAC_Chennel.m
//  RAC_StudyTests
//
//  Created by zidonj on 2020/4/2.
//  Copyright © 2020 zidonj. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface RAC_Chennel : XCTestCase

@end

@implementation RAC_Chennel

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    RACChannel *channel = [[RACChannel alloc] init];

    [channel.leadingTerminal subscribeNext:^(id x) {
        NSLog(@"channel -- leading -- %@", x);
    } error:^(NSError *error) {
        NSLog(@"channel -- leading -- error");
    } completed:^{
        NSLog(@"channel -- leading -- completed");
    }];

    [channel.followingTerminal subscribeNext:^(id x) {
        NSLog(@"channel -- following -- %@", x);
    } error:^(NSError *error) {
        NSLog(@"channel -- following -- error");
    } completed:^{
        NSLog(@"channel -- following -- completed");
    }];

    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(1)];
        [subscriber sendCompleted];

        return nil;
    }];

//    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [subscriber sendNext:@(2)];
//        [subscriber sendError:nil];
//
//        return nil;
//    }];
    
    [signal1 subscribe:channel.leadingTerminal];
//    [signal2 subscribe:channel.followingTerminal];
}

- (void)testExample2 {
    RACChannel *channel = [[RACChannel alloc] init];

    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(1)];
        [subscriber sendCompleted];

        return nil;
    }];

    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(2)];
        [subscriber sendError:nil];

        return nil;
    }];

    [signal1 subscribe:channel.leadingTerminal];

    [channel.leadingTerminal subscribeNext:^(id x) {
        NSLog(@"channel -- leading -- %@", x);
    } error:^(NSError *error) {
        NSLog(@"channel -- leading -- error");
    } completed:^{
        NSLog(@"channel -- leading -- completed");
    }];

    [channel.followingTerminal subscribeNext:^(id x) {
        NSLog(@"channel -- following -- %@", x);
    } error:^(NSError *error) {
        NSLog(@"channel -- following -- error");
    } completed:^{
        NSLog(@"channel -- following -- completed");
    }];

    [signal2 subscribe:channel.followingTerminal];
}

- (void)testExample3 {
    RACChannel *channel = [[RACChannel alloc] init];

    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(1)];
        [subscriber sendCompleted];

        return nil;
    }];

    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(2)];
        [subscriber sendError:nil];

        return nil;
    }];

    [signal1 subscribe:channel.leadingTerminal];
    [signal2 subscribe:channel.followingTerminal];

    [channel.leadingTerminal subscribeNext:^(id x) {
        NSLog(@"channel -- leading -- %@", x);
    } error:^(NSError *error) {
        NSLog(@"channel -- leading -- error");
    } completed:^{
        NSLog(@"channel -- leading -- completed");
    }];

    [channel.followingTerminal subscribeNext:^(id x) {
        NSLog(@"channel -- following -- %@", x);
    } error:^(NSError *error) {
        NSLog(@"channel -- following -- error");
    } completed:^{
        NSLog(@"channel -- following -- completed");
    }];
    UIView *v;
    RACChannelTo(v,backgroundColor,UIColor.redColor);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
