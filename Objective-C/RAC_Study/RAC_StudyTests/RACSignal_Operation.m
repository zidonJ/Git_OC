//
//  RACSignal_Operation.m
//  RAC_StudyTests
//
//  Created by zidonj on 2020/5/7.
//  Copyright © 2020 zidonj. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal_Operation : XCTestCase

@end

@implementation RACSignal_Operation

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    //数组中的信号合并为一个信号。至少两个信号完成信息的发送 才可以正常执行
    RACSubject *oneSubejct = [RACSubject subject];
    RACSubject *baseSignal = [RACSubject subject];
    [[RACSignal combineLatest:@[baseSignal,oneSubejct]] subscribeNext:^(id x) {
        NSLog(@"信号发送combineLatest:%@",x);
    }];
    
    [oneSubejct sendNext:@"testBac222"];
    [baseSignal sendNext:@"111testBac"];
}

- (void)testMerge {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    //数组中的信号合并为一个信号。只要有任意一个信号完成信息的发送 就可以正常执行
    RACSubject *oneSubejct = [RACSubject subject];
    RACSubject *baseSignal = [RACSubject subject];
    [[RACSignal merge:@[baseSignal,oneSubejct]] subscribeNext:^(id x) {
        NSLog(@"信号发送combineLatest:%@",x);
    }];
    
    
    [baseSignal sendNext:@"testBac222"];
    [baseSignal sendNext:@"111testBac"];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
