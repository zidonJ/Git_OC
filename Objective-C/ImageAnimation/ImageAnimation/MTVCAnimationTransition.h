

#pragma mark Constants


#pragma mark - Enumerations


#pragma mark - Class Interface

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MTVCAnimationTransition : NSObject<UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>


#pragma mark - Properties

@property (nonatomic,assign) BOOL isPush;

@property (nonatomic,weak) UIPanGestureRecognizer *panGesture;

#pragma mark - Constructors


#pragma mark - Static Methods


#pragma mark - Instance Methods

- (void)setRelyPanGesture:(UIPanGestureRecognizer *)pan;


@end
