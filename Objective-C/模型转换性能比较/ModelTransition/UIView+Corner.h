//
//  UIView+Corner.h
//  CollectionLayoutTest
//
//  Created by 姜泽东 on 2017/10/11.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Corner)

- (UIImage *)drawRectWithCorner:(float)radius
                        bgColor:(UIColor *)bgColor
                    borderWidth:(float)borderWidth
                    borderColor:(UIColor *)borderColor;


- (void)addCorner:(float)radius
          bgColor:(UIColor *)bgColor
      borderWidth:(float)borderWidth
      borderColor:(UIColor *)borderColor;


@end
