#import "MTDrivenInteractive.h"
#import "MTVCTransitonProtocol.h"

#pragma mark Constants


#pragma mark - Class Extension

@interface MTDrivenInteractive ()
{
    BOOL _isFirst;
}
@property (nonatomic,strong) UIPanGestureRecognizer *pan;
@property (nonatomic,weak) id<UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic,strong) UIView *fromView;
@property (nonatomic,strong) UIView *toView;

@property (nonatomic,strong) UIImage *transitionImage;
@property (nonatomic,strong) UIView *transitionImageView;

@property (nonatomic,assign) CGRect transitionOriginalImgFrame;
@property (nonatomic,assign) CGRect transitionBrowserImgFrame;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation MTDrivenInteractive


#pragma mark - Properties


#pragma mark - Constructors



#pragma mark - Public Methods

- (void)setRelyPanGesture:(UIPanGestureRecognizer *)pan
{
    _isFirst = YES;
    _pan = pan;
    [_pan addTarget:self action:@selector(updateView:)];
}


#pragma mark - Overridden Methods

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    _transitionContext = transitionContext;
}

#pragma mark - Private Methods

- (void)updateView:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:pan.view.superview];
    
    CGFloat scale = 1 - translation.y / [pan.view bounds].size.height;
    
    scale = scale > 1 ? 1:scale;
    scale = scale < 0 ? 0:scale;
    
    if (_isFirst) {
        [self beginInterPercent];
        _isFirst = NO;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
            
            [self updateInteractiveTransition:scale];

            break;
        case UIGestureRecognizerStateEnded:
            
//            if (translation.y <= 80) {
//                [self cancelInteractiveTransition];
//                
//                [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
//
//            }else {
//                [self finishInteractiveTransition];
//                [self interPercentFinish];
//            }
            
            
            
            break;
            
        default:
            break;
    }
    
    [pan setTranslation:CGPointZero inView:pan.view.superview];
}

- (void)beginInterPercent {
    
    // 转场过渡的容器view
    UIView *containerView = [_transitionContext containerView];
    if (containerView) {
        
        // ToVC
        UIViewController<MTVCTransitonProtocol> *toViewController = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        if ([toViewController isKindOfClass:[UINavigationController class]]) {
            NSArray<UIViewController<MTVCTransitonProtocol> *> *array = [(UINavigationController *)toViewController viewControllers];
            toViewController = array.lastObject;
        }
        
        _toView = toViewController.view;
        _toView.hidden = NO;
        
        [containerView addSubview:_toView];
        
        // 有渐变的黑色背景
//        UIView *blackBgView = [[UIView alloc] initWithFrame:containerView.bounds];
//        blackBgView.backgroundColor = [UIColor blackColor];
//        blackBgView.hidden = NO;
//
//        [containerView addSubview:blackBgView];
        
        
        // fromVC
        UIViewController<MTVCTransitonProtocol> *fromViewController = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        _fromView = fromViewController.view;
        _fromView.backgroundColor = [UIColor clearColor];
        _fromView.hidden = NO;
        [containerView addSubview:_fromView];
        
    }
}
//
//- (void)interPercentFinish {
//    
//    
//    _fromView.hidden = YES;
//    
//    // 转场过渡的容器view
//    UIView *containerView = [_transitionContext containerView];
//    if (containerView) {
//        
//        // 过度的图片
//        UIView *transitionImgView = _transitionImageView==nil ?[[UIImageView alloc] initWithImage:_transitionImage]:_transitionImageView;
//        transitionImgView.clipsToBounds = YES;
//        transitionImgView.frame = _transitionBrowserImgFrame;
//        [containerView addSubview:transitionImgView];
//        
//        if transitionOriginalImgFrame == CGRect.zero ||
//            (transitionImage == nil && transitionImageView == nil) {
//                
//                UIView.animate(withDuration: 0.3, animations: { [weak self] in
//                    
//                    transitionImgView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//                    transitionImgView.alpha = 0
//                    self?.blackBgView?.alpha = 0
//                    
//                }, completion: { [weak self] (finished:Bool) in
//                    
//                    self?.blackBgView?.removeFromSuperview()
//                    transitionImgView.removeFromSuperview()
//                    
//                    transitionContext?.completeTransition(!(transitionContext?.transitionWasCancelled)!)
//                    
//                })
//                
//                return
//            }
//        
//        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.curveLinear, animations: { [weak self] in
//            
//            transitionImgView.frame = (self?.transitionOriginalImgFrame)!
//            self?.blackBgView?.alpha = 0
//            
//        }) { [weak self] (finished: Bool) in
//            
//            self?.blackBgView?.removeFromSuperview()
//            transitionImgView.removeFromSuperview()
//            
//            transitionContext?.completeTransition(!(transitionContext?.transitionWasCancelled)!)
//            
//        }
//    }
//}


@end
