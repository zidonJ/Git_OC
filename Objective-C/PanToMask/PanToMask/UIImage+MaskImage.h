//
//  UIImage+MaskImage.h
//  PanToMask
//
//  Created by 姜泽东 on 2017/10/20.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MaskImage)

+ (UIImage *)transToMosaicImage:(UIImage*)orginImage blockLevel:(NSUInteger)level;

@end
