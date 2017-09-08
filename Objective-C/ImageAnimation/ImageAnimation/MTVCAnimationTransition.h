

#pragma mark Constants


#pragma mark - Enumerations


#pragma mark - Class Interface

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 UIViewControllerAnimatedTransitioning:在代理里面操作动画之行
 UIViewControllerTransitioningDelegate:本类就是做为这个协议的代理,用于present的过场动画控制(push和pop的动画由Navgation的代理实现控制)
 */

@interface MTVCAnimationTransition : NSObject<UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>


#pragma mark - Properties

@property (nonatomic,assign) BOOL isPush;

@property (nonatomic,weak) UIPanGestureRecognizer *panGesture;

#pragma mark - Constructors


#pragma mark - Static Methods


#pragma mark - Instance Methods

- (void)setRelyPanGesture:(UIPanGestureRecognizer *)pan;


@end
