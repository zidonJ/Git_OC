//
//  UIView+Transform.h
//  PanToMask
//
//  Created by 姜泽东 on 2017/12/16.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Transform)<CAAnimationDelegate>

-(void)transformCircleToColor:(UIColor*)toColor Duration:(CGFloat)duration StartPoint:(CGPoint)startPoint;

-(void)transformCircleToImage:(UIImage*)toImage Duration:(CGFloat)duration StartPoint:(CGPoint)startPoint;

-(void)transFormBeginZoomMax:(CGFloat)max min:(CGFloat)min;
-(void)transFormStopZoom;


@end
