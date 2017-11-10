//
//  HYScratchCardView.h
//  PanToMask
//
//  Created by 姜泽东 on 2017/10/20.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanToMaskView : UIView

/**
 要刮的底图.
 */
@property (nonatomic, strong) UIImage *image;
/**
 涂层图片.
 */
@property (nonatomic, strong) UIImage *surfaceImage;

@end
