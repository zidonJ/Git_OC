//
//  TGDrawSvgPathView.m
//  SVGPathDrawing
//
//  Created by Thibault Guégan on 09/07/2014.
//  Copyright (c) 2014 Skyr. All rights reserved.
//

#import "TGDrawSvgPathView.h"

@implementation TGDrawSvgPathView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _shapeView = [[CAShapeLayer alloc] init];
    }
    return self;
}

-(void)createImageWithPath:(NSString *)fileName
{
    _strokeColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1];
    
    [_shapeView setPath:[PocketSVG pathFromSVGFileNamed:fileName]];
    
    [self getSvgImage];
}

/**
 先获取svg图形的图片
 */
- (void)getSvgImage
{
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    
    CAShapeLayer *shp=[self getShapeLayer];
    [self.layer addSublayer:shp];
    
    [self.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _imgv=[[UIImageView alloc] initWithFrame:self.frame];
    _imgv.image=image;
    
    [self.superview addSubview:_imgv];
    [shp removeFromSuperlayer];
}

- (void)setPathFromSvg:(NSString*)fileName strokeColor:(UIColor *)color duration:(CFTimeInterval)time
{
    _strokeColor = color;
    _animationDuration = time;
    [_shapeView setPath:[PocketSVG pathFromSVGFileNamed:fileName]];
    
    [self scale];
}

/**
 做svg动画
 */
- (void)scale
{
    [self.layer insertSublayer:[self getShapeLayer] above:_imgv.layer];
}

-(CAShapeLayer *)getShapeLayer
{
    CGRect boundingBox = CGPathGetBoundingBox(_shapeView.path);
    CGFloat boundingBoxAspectRatio = CGRectGetWidth(boundingBox)/CGRectGetHeight(boundingBox);
    CGFloat viewAspectRatio = CGRectGetWidth(self.frame)/CGRectGetHeight(self.frame);
    
    CGFloat scaleFactor = 1.0;
    if (boundingBoxAspectRatio > viewAspectRatio) {
        scaleFactor = CGRectGetWidth(self.frame)/CGRectGetWidth(boundingBox);
    } else {
        scaleFactor = CGRectGetHeight(self.frame)/CGRectGetHeight(boundingBox);
    }
    
    CGAffineTransform scaleTransform = CGAffineTransformIdentity;
    scaleTransform = CGAffineTransformScale(scaleTransform, scaleFactor, scaleFactor);
    scaleTransform = CGAffineTransformTranslate(scaleTransform, -CGRectGetMinX(boundingBox), -CGRectGetMinY(boundingBox));
    
    CGSize scaledSize = CGSizeApplyAffineTransform(boundingBox.size, CGAffineTransformMakeScale(scaleFactor, scaleFactor));
    CGSize centerOffset = CGSizeMake((CGRectGetWidth(self.frame)-scaledSize.width)/(scaleFactor*2.0),
                                     (CGRectGetHeight(self.frame)-scaledSize.height)/(scaleFactor*2.0));
    scaleTransform = CGAffineTransformTranslate(scaleTransform, centerOffset.width, centerOffset.height);
    
    CGPathRef scaledPath = CGPathCreateCopyByTransformingPath(_shapeView.path,&scaleTransform);
    CAShapeLayer *scaledShapeLayer = [CAShapeLayer layer];
    scaledShapeLayer.path = scaledPath;
    scaledShapeLayer.strokeColor = _strokeColor.CGColor;
    scaledShapeLayer.fillColor = [UIColor clearColor].CGColor;
    scaledShapeLayer.lineWidth = 1.0;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = _animationDuration;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [scaledShapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    CGPathRelease(scaledPath);
    return scaledShapeLayer;
}

@end
