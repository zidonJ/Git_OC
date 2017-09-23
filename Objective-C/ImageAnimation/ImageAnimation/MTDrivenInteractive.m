//
//  MTDrivenInteractive.m
//  ImageAnimation
//
//  Created by 姜泽东 on 2017/9/13.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "MTDrivenInteractive.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface MTDrivenInteractive ()
{
    id<UIViewControllerContextTransitioning> _context;
    UIView *_transitioningView;
}
@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation MTDrivenInteractive


#pragma mark - Properties


#pragma mark - Constructors

- (id)init
{
	// Abort if base initializer fails.
	if ((self = [super init]) == nil)
	{
		return nil;
	}
	
	// Initialize instance variables.
	
	// Return initialized instance.
	return self;
}


#pragma mark - Public Methods


#pragma mark - Overridden Methods


#pragma mark - Private Methods



#pragma mark -- UIViewControllerInteractiveTransitioning --



@end
