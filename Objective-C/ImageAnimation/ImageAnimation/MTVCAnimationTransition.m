#import "MTVCAnimationTransition.h"
#import "MTVCTransitonProtocol.h"

#pragma mark Constants


#pragma mark - Class Extension

@interface MTVCAnimationTransition ()


@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation MTVCAnimationTransition


#pragma mark - Properties


#pragma mark - Constructors


#pragma mark - Public Methods

- (void)setRelyPanGesture:(UIPanGestureRecognizer *)pan
{
    
}


#pragma mark - Overridden Methods


#pragma mark - Private Methods

#pragma mark -- delegate methods

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return .5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController<MTVCTransitonProtocol> *fromVC = nil;
    __block UIViewController<MTVCTransitonProtocol> *toVC = nil;
    
    toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *contView = [transitionContext containerView];
    UIImageView *imgView = [UIImageView new];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    [contView addSubview:toVC.view];
    [toVC.view layoutIfNeeded];
    [contView addSubview:imgView];
    
    if ([fromVC isKindOfClass:[UINavigationController class]]) {
        NSArray<UIViewController<MTVCTransitonProtocol> *> *array = [(UINavigationController *)fromVC viewControllers];
        fromVC = array.lastObject;
    }
    
    if ([toVC isKindOfClass:[UINavigationController class]]) {
        NSArray<UIViewController<MTVCTransitonProtocol> *> *array = [(UINavigationController *)toVC viewControllers];\
        toVC = array.lastObject;
    }
    
    imgView.image = fromVC.image;
    imgView.frame = fromVC.imageFrame;
    
    toVC.imageTargetView.alpha = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        
        imgView.frame = toVC.imageFrame;

    } completion:^(BOOL finished) {
        
        toVC.imageTargetView.alpha = 1;
        [imgView removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        //NSLog(@"%@-%@",toVC,fromVC);
    }];
    
    
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

//- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
//{
//
//}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

//- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source
//{
//
//}


@end
