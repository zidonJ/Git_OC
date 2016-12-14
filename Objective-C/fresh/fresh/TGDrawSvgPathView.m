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
        // Initialization code
        _shapeView = [[CAShapeLayer alloc] init];
    }
    return self;
}

-(void)createImageWithPath:(NSString *)fileName
{
    _strokeColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1];

    [_shapeView setPath:[PocketSVG pathFromSVGFileNamed:fileName]];
    
    [self scale1];
}

- (void)scale1
{
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    
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
    
    [self.layer addSublayer:scaledShapeLayer];
    
    [self.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    CGRect rect=[self convertRect:self.frame toView:self.superview];
    _imgv=[[UIImageView alloc] initWithFrame:self.frame];
    _imgv.image=image;
    
    [self.superview addSubview:_imgv];
    [scaledShapeLayer removeFromSuperlayer];
    
    CGPathRelease(scaledPath);
}

- (void)setPathFromSvg:(NSString*)fileName strokeColor:(UIColor *)color duration:(CFTimeInterval)time
{
    
    _strokeColor = color;
    _animationDuration = time;
    
    [_shapeView setPath:[PocketSVG pathFromSVGFileNamed:fileName]];
    
    [self scale];
}

- (void)scale
{
    
    // I'm assuming that the view and original shape layer is already created
    CGRect boundingBox = CGPathGetBoundingBox(_shapeView.path);
    
    CGFloat boundingBoxAspectRatio = CGRectGetWidth(boundingBox)/CGRectGetHeight(boundingBox);
    CGFloat viewAspectRatio = CGRectGetWidth(self.frame)/CGRectGetHeight(self.frame);
    
    CGFloat scaleFactor = 1.0;
    if (boundingBoxAspectRatio > viewAspectRatio) {
        // Width is limiting factor
        scaleFactor = CGRectGetWidth(self.frame)/CGRectGetWidth(boundingBox);
    } else {
        // Height is limiting factor
        scaleFactor = CGRectGetHeight(self.frame)/CGRectGetHeight(boundingBox);
    }
    
    // Scaling the path ...
    CGAffineTransform scaleTransform = CGAffineTransformIdentity;
    // Scale down the path first
    scaleTransform = CGAffineTransformScale(scaleTransform, scaleFactor, scaleFactor);
    // Then translate the path to the upper left corner
    scaleTransform = CGAffineTransformTranslate(scaleTransform, -CGRectGetMinX(boundingBox), -CGRectGetMinY(boundingBox));
    
    // If you want to be fancy you could also center the path in the view
    // i.e. if you don't want it to stick to the top.
    // It is done by calculating the heigth and width difference and translating
    // half the scaled value of that in both x and y (the scaled side will be 0)
    CGSize scaledSize = CGSizeApplyAffineTransform(boundingBox.size, CGAffineTransformMakeScale(scaleFactor, scaleFactor));
    CGSize centerOffset = CGSizeMake((CGRectGetWidth(self.frame)-scaledSize.width)/(scaleFactor*2.0),
                                     (CGRectGetHeight(self.frame)-scaledSize.height)/(scaleFactor*2.0));
    scaleTransform = CGAffineTransformTranslate(scaleTransform, centerOffset.width, centerOffset.height);
    // End of "center in view" transformation code
    
    CGPathRef scaledPath = CGPathCreateCopyByTransformingPath(_shapeView.path,
                                                              &scaleTransform);
    
    // Create a new shape layer and assign the new path
    _scaledShapeLayer = [CAShapeLayer layer];
    _scaledShapeLayer.path = scaledPath;
    _scaledShapeLayer.strokeColor = _strokeColor.CGColor;
    _scaledShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _scaledShapeLayer.lineWidth = 1.0;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = _animationDuration;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [_scaledShapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    //add the shape layer to our custom view
//    [self.layer addSublayer:_scaledShapeLayer];
    [self.layer insertSublayer:_scaledShapeLayer above:_imgv.layer];
    
    CGPathRelease(scaledPath); // release the copied path
}

@end
