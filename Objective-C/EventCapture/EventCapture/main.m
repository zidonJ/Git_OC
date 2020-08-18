//
//  main.m
//  EventCapture
//
//  Created by zidon on 16/8/17.
//  Copyright © 2016年 zidon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RunloopEventCapture.h"

int main(int argc, char * argv[]) {
    
    inception_runloop();
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
