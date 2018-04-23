//
//  UIView+RoundedCorners.m
//  UIViewRoundedCorners
//
//  Created by Vashishtha Jogi on 11/20/11.
//  Copyright (c) 2011 Vashishtha Jogi. All rights reserved.
//

#import "UIView+RoundedCorners.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (RoundedCorners)

-(void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius borderColor:(UIColor *)color
             borderWidth:(CGFloat)width
{
    [self.superview layoutIfNeeded];
    CGRect rect = self.bounds;
    
    // Create the path
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    maskLayer.strokeColor = nil;
    self.layer.mask = maskLayer;
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = rect;
    borderLayer.lineWidth = width;
    borderLayer.strokeColor = color.CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.path = maskPath.CGPath;
    [self.layer addSublayer:borderLayer];
    
}

@end
