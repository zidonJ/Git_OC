//
//  LittlePointUnitTests.m
//  LittlePointUnitTests
//
//  Created by jiangzedong on 2021/10/31.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface LittlePointUnitTests : XCTestCase

@property (nonatomic, strong) ViewController *vc;

@end

@implementation LittlePointUnitTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.vc = (ViewController *)UIApplication.sharedApplication.windows[0].rootViewController;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)scrollTop {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)scrollDown {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testResetWith5
{
    [self.vc.v reloadUIWithCount:5 selectIndex:2];
}

- (void)testResetWith6
{
    
}

- (void)testResetWith7
{
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
