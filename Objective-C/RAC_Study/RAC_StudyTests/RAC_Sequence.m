//
//  RAC_Sequence.m
//  RAC_StudyTests
//
//  Created by zidonj on 2020/1/21.
//  Copyright © 2020 zidonj. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface RAC_Sequence : XCTestCase

@end

@implementation RAC_Sequence

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    
    NSArray * array = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"数组内容：%@", x);
    }];
    
    NSArray * newArray = [[array.rac_sequence map:^id _Nullable(id  _Nullable value) {
        NSLog(@"原数组内容%@",value);
        return @"99";
    }] array];
    NSLog(@"%@",newArray);
    
    NSDictionary * dic = @{@"name":@"Tom",@"age":@"20"};
    [dic.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        RACTupleUnpack(NSString *key, NSString * value) = x;//X为为一个元祖，RACTupleUnpack能够将key和value区分开
        NSLog(@"数组内容：%@--%@",key,value);
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
