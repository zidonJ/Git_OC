//
//  ViewController.m
//  PanToMask
//
//  Created by 姜泽东 on 2017/10/20.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "ViewController.h"
#import "PanToMaskView.h"
#import "UIImage+MaskImage.h"
#import "UIView+Transform.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PanToMaskView *v = [[PanToMaskView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:v];
    UIImage *image = [UIImage imageNamed:@"11"];

    [v setImage:[UIImage transToMosaicImage:image blockLevel:10]];
    [v setSurfaceImage:image];
    
    
    /*
     这里详细解释Mask layer一旦变为mask 透明部分就不再显示了 所以我们需要设置不显示的部分就需要设置成透明色
     这里选择了[UIColor clearColor]而不是‘label.alpha = 0’ 因为透明度为0后(所有都透明)‘文字’也变得透明了
     也就不显示了  被设置成layer的Mask在设置成之前需要先加在页面上才能渲染成为Mask
     */
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 100)];
//    label.backgroundColor = [UIColor clearColor];
//    label.text = @"李沁";
//    label.alpha = 1;
//    label.textColor = [UIColor redColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:label];
//
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 100, 100)];
//    v.backgroundColor = [UIColor purpleColor];
//    [self.view addSubview:v];
//
//    v.layer.mask = label.layer;
    //label.frame = v.bounds;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self.view transformCircleToColor:[UIColor redColor] Duration:1 StartPoint:CGPointZero];
}


@end
