//
//  MTGestureBackAnimation.m
//  ImageAnimation
//
//  Created by 姜泽东 on 2017/9/6.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "MTGestureBackAnimation.h"

#pragma mark Constants


#pragma mark - Class Extension

@interface MTGestureBackAnimation ()
{
    CGFloat _startScale, _completionSpeed;
    id<UIViewControllerContextTransitioning> _context;
    UIView *_transitioningView;
    UIPinchGestureRecognizer *_pinchRecognizer;
    UIViewController *_animationController;
    
}
@property (nonatomic,assign) GestureBackType backType;
@property (nonatomic,assign) InteractiveAnimationType interactiveType;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation MTGestureBackAnimation


#pragma mark - init

- (instancetype)initWithController:(UIViewController *)viewController backType:(GestureBackType)type
{
    self = [super init];
    if (self) {
        _animationController = viewController;
        _backType = type;
        [self setInteractiveViewController:_animationController];
    }
    return self;

}

#pragma mark - Public Methods

- (void)setGestureBackType:(GestureBackType)type
{
    _backType = type;
}

- (void)setInteractiveViewController:(UIViewController *)viewController
{
    if (_backType == PanDown) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBack:)];
        [viewController.view addGestureRecognizer:pan];
    }else {
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchBack:)];
        [viewController.view addGestureRecognizer:pinch];
    }
    _animationController = viewController;
}

#pragma mark - Overridden Methods

#pragma mark - Private Methods

- (void)panBack:(UIPanGestureRecognizer *)pan
{

}

-(void)pinchBack:(UIPinchGestureRecognizer *)pinch {
    CGFloat scale = pinch.scale;
    switch (pinch.state) {
        case UIGestureRecognizerStateBegan:{
            _startScale = scale;
            self.interactive = YES;
            [_animationController dismissViewControllerAnimated:YES completion:nil];
            
//            [_animationController.navigationController popViewControllerAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat percent = (1.0 - scale/_startScale);
            [self updateWithPercent:(percent < 0.0) ? 0.0 : percent];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGFloat percent = (1.0 - scale/_startScale);
            BOOL cancelled = ([pinch velocity] < 5.0 && percent <= 0.3);
            [self end:cancelled];
            
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            CGFloat percent = (1.0 - scale/_startScale);
            BOOL cancelled = ([pinch velocity] < 5.0 && percent <= 0.3);
            [self end:cancelled];
            break;
        }
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }
}

#pragma mark -- UIViewControllerAnimatedTransitioning --

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return .5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //Get references to the view hierarchy
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.interactiveType == AnimationTypeGo) {
        //Add 'to' view to the hierarchy with 0.0 scale
        toViewController.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
        [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
        
        //Scale the 'to' view to to its final position
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else if (self.interactiveType == AnimationTypeBack) {
        //Add 'to' view to the hierarchy
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        
        //Scale the 'from' view down until it disappears
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

-(void)animationEnded:(BOOL)transitionCompleted {
    self.interactive = NO;
}

#pragma mark -- UIViewControllerInteractiveTransitioning --
-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //Maintain reference to context
    _context = transitionContext;
    
    //Get references to view hierarchy
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //Insert 'to' view into hierarchy
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    //Save reference for view to be scaled
    _transitioningView = fromViewController.view;
}

-(void)updateWithPercent:(CGFloat)percent {
    CGFloat scale = fabs(percent-1.0);
    _transitioningView.transform = CGAffineTransformMakeScale(scale, scale);
    [_context updateInteractiveTransition:percent];
}

-(void)end:(BOOL)cancelled {
    
   
    
    
    if (cancelled) {
        [UIView animateWithDuration:_completionSpeed animations:^{
            _transitioningView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            [_context cancelInteractiveTransition];
            [_context completeTransition:NO];
        }];
    } else {
        [UIView animateWithDuration:_completionSpeed animations:^{
            _transitioningView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        } completion:^(BOOL finished) {
            [_context finishInteractiveTransition];
            [_context completeTransition:YES];
        }];
    }
}



#pragma mark -- UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return self;
}

@end
