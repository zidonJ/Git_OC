//
//  ViewController.m
//  ImageAnimation
//
//  Created by 姜泽东 on 2017/9/6.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "ViewController.h"

#import "MTVCAnimationTransition.h"
#import "MTImageVC.h"

@interface ViewController ()<UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic,strong) MTVCAnimationTransition *animation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.delegate = self;
    
    self.image = [UIImage imageNamed:@"2.jpeg"];
    
    _animation = [MTVCAnimationTransition new];
    self.transitioningDelegate = _animation;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    if (operation != UINavigationControllerOperationNone) {
        MTVCAnimationTransition *animation = [MTVCAnimationTransition new];
        animation.isPush = operation == UINavigationControllerOperationPush;
        return animation;
    }
    return nil;
}

- (UIImage *)image
{
    return _image;
}

- (CGRect)imageFrame
{
    return self.imgView.frame;
}

- (UIView *)imageTargetView
{
    return self.imgView;
}

- (IBAction)jump:(id)sender {
    
    MTImageVC *ani = (MTImageVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ani"];
    ani.image = self.image;
    //ani.ani = _animation;
    [self presentViewController:ani animated:YES completion:nil];
//    [self.navigationController pushViewController:ani animated:YES];
}

@end
