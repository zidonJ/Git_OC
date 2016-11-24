//
//  PickColorView.h
//  RibbonIpad
//
//  Created by Zhongwei Sun on 11-10-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickColorView : UIView {
    int width;
    int height;
    UIImageView *pickedColorImageView;
    UIColor *currentColor;
}

@property (nonatomic, retain) IBOutlet UIImageView *pickedColorImageView;
@property (nonatomic, retain) UIColor *currentColor;
- (id)initWithCoder:(NSCoder *)aDecoder andSourceImage:(UIImage *)aImage;
- (void)showColorAtPoint:(CGPoint)aPoint;
- (void)setSourceImage:(UIImage *)sourceImage;
@end
