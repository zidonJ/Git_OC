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
#import "MTTestVCBack.h"

@interface ViewController ()<UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.delegate = self;
    
    self.image = [UIImage imageNamed:@"2.jpeg"];
    
}

//点击
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

//手势
-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    
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
    [self presentViewController:ani animated:YES completion:nil];
    
//    [self.navigationController pushViewController:ani animated:YES];
}

@end
