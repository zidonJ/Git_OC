//
//  ShowProgressView.m
//  AVPlayer0Go
//
//  Created by zidon on 15/12/2.
//  Copyright © 2015年 zidon. All rights reserved.
//

#import "ShowProgressView.h"

@interface ShowProgressView ()

@property (nonatomic,assign) float length;
@property (nonatomic,assign) float width;

@end

@implementation ShowProgressView

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context=UIGraphicsGetCurrentContext();
    [[UIColor blueColor] set];
    CGContextMoveToPoint(context, 0, 1);
    CGContextAddLineToPoint(context, _length, 1);
    CGContextSetLineWidth(context, _width);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

-(void)drawLength:(float)LineLength andHeight:(float)lineWidth
{
    _length=LineLength;
    _width=lineWidth;
    [self setNeedsDisplay];
}

@end
