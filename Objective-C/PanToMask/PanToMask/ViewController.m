//
//  ViewController.m
//  PanToMask
//
//  Created by 姜泽东 on 2017/10/20.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "ViewController.h"
#import "HYScratchCardView.h"
#import "UIImage+MaskImage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    HYScratchCardView *v = [[HYScratchCardView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:v];
    UIImage *image = [UIImage imageNamed:@"11"];
    
    [v setImage:[UIImage transToMosaicImage:image blockLevel:10]];
    [v setSurfaceImage:image];
}




@end
