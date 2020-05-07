//
//  RACStream_Operation.m
//  RAC_StudyTests
//
//  Created by zidonj on 2020/5/7.
//  Copyright © 2020 zidonj. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface RACStream_Operation : XCTestCase

@end

@implementation RACStream_Operation

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

/*
 （a）flattenMap：在bind基础上封装的改变方法，用自己提供的block，改变当前流，变成block返回的流对象。
  
 （b）flatten：在flattenMap基础封装的改变方法，如果当前反应流中的对象也是一个流的话，就可以将当前流变成当前流中的流对象
  
 （c）map：在flattenMap基础上封装的改变方法，在flattenMap中的block中返回的值必须也是流对象，而map则不需要，它是将流中的对象执行block后，用流的return方法将值变成流对象。
  
 （d）mapReplace：在map的基础上封装的改变方法，直接替换当前流中的对象，形成一个新的对象流。
  
 （e）filter：在Map基础上封装的改变封装，过滤掉当前流中不符合要求的对象，将之变为空流
  
 （f）ignore：在filter基础封装的改变方法，忽略和当前值一样的对象，将之变为空流
  
 （g）skip：在bind基础上封装的改变方法，忽略当前流前n次的对象值，将之变为空流
  
 （h）take：在bind基础上封装的改变方法，只区当前流中的前n次对象值，之后将流变为空（不是空流）。
  
 （i）distinctUntilChanged：在bind基础封装的改变方法，当流中后一次的值和前一次的值不同的时候，才会返回当前值的流，否则返回空流（第一次默认被忽略）
  
 （j）takeUntilBlock：在bind基础封装的改变方法，取当前流的对象值，直到当前值满足提供的block，就会将当前流变为空（不是空流）
  
 （k）takeWhileBlock：在bind基础封装的改变方法，取当前流的对象值，直到当前值不满足提供的block，就会将当前流变为空（不是空流）
  
 （l）skipUntilBlock：在bind基础封装的改变方法，忽略当前流的对象值（变为空流），直到当前值满足提供的block。
  
 （m）skipWhileBlock：在bind基础封装的改变方法，忽略当前流的对象值（变为空流），直到当前值不满足提供的block
  
 （n）scanWithStart：reduceWithIndex：在bind基础封装的改变方法，用同样的block执行每次流中的值，并将结果用于后一次执行当中，每次都把block执行后的值变成新的流中的对象。
  
 （o）startWIth：在contact基础上封装的多流之间的顺序方法，在当前流的值流出之前，加入一个初始值
  
 （p）zip：打包多流，将多个流中的值包装成一个RACTuple对象
  
 （q）reduceEach：将流中的RACTuple对象进行过滤，返回特定的衍生出的一个值对象
 */

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
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
    
    [[signal flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return [RACSignal return:@([(NSNumber *)value intValue]*10)];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"flattenMap: %@", x);
    }];
        
    [[signal skipWhileBlock:^BOOL(id  _Nullable x) {
        return [x isEqual:@1];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"skipWhileBlock: %@", x);
    }];
    
    [[signal skipUntilBlock:^BOOL(id  _Nullable x) {
        return [x isEqual:@4];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"skipUntilBlock: %@", x);
    }];
    
    [[signal take:2] subscribeNext:^(id  _Nullable x) {
        
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
