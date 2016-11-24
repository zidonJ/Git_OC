//
//  DrawAppDelegate.h
//  Draw
//
//  Created by Zhongwei Sun on 11-10-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DrawViewController;

@interface DrawAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet DrawViewController *viewController;

@end
