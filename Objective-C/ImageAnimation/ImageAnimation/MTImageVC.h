//
//  MTImageVC.h
//  ImageAnimation
//
//  Created by 姜泽东 on 2017/9/6.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Enumerations



@interface MTImageVC : UIViewController


#pragma mark - Properties

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic,copy) UIImage *image;


@end
