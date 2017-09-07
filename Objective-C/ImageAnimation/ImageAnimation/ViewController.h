//
//  ViewController.h
//  ImageAnimation
//
//  Created by 姜泽东 on 2017/9/6.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTVCTransitonProtocol.h"

@interface ViewController : UIViewController<MTVCTransitonProtocol>

@property (nonatomic,copy) UIImage *image;

@end

