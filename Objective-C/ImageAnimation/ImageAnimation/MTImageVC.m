#import "MTImageVC.h"
#import "MTVCTransitonProtocol.h"
#import "MTVCAnimationTransition.h"

#pragma mark Constants

#pragma mark - Class Extension

@interface MTImageVC ()<MTVCTransitonProtocol>
{
    CGFloat _panBeginScaleX;
    CGFloat _panBeginScaleY;
    CGRect transitionImageViewFrame;
}
@property (nonatomic,strong) UIImageView *ttImgView;
@property (nonatomic,strong) MTVCAnimationTransition *ani;
@property (nonatomic,strong) UIPanGestureRecognizer *pan;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation MTImageVC


#pragma mark - Properties


#pragma mark - Public Methods


#pragma mark - Overridden Methods

- (void)dealloc
{
    self.transitioningDelegate = nil;
    NSLog(@"%@",[self class]);
}

- (void)viewDidLoad
{
    // Call base implementation.
    [super viewDidLoad];
    
    
    self.imgView.userInteractionEnabled = YES;
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.imgView addGestureRecognizer:_pan];
    
    _ani = [MTVCAnimationTransition new];
    [_ani setRelyPanGesture:_pan];
    self.transitioningDelegate = _ani;
}

#pragma mark - Private Methods

- (CGRect)imageFrame
{
    return self.imgView.frame;
}

- (UIView *)imageTargetView
{
    return self.imgView;
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    
    CGPoint point = [pan translationInView:self.imgView];
    CGFloat scale = 1 - point.y / [[UIScreen mainScreen] bounds].size.height;
    
//    scale = scale > 1 ? 1:scale;
//    scale = scale < 0 ? 0:scale;
    
    if (pan.state == UIGestureRecognizerStateBegan) {
//        CGPoint point = [pan translationInView:self.imgView];
//        
//        transitionImageViewFrame = _imgView.frame;
//        
//        _panBeginScaleX = [pan locationInView:pan.view].x / transitionImageViewFrame.size.width;
//        _panBeginScaleY = [pan locationInView:_imgView].y / _imgView.frame.size.height;
//        
//        if (_panBeginScaleX < 0)  {
//            _panBeginScaleX = 0;
//        }else if (_panBeginScaleX > 1)  {
//            _panBeginScaleX = 1;
//        }
//        
//        if (_panBeginScaleY < 0) {
//            _panBeginScaleY = 0;
//        }else if (_panBeginScaleY > 1) {
//            _panBeginScaleY = 1;
//        }
        
        transitionImageViewFrame = _imgView.frame;
        _panBeginScaleX = [pan locationInView:pan.view].x / transitionImageViewFrame.size.width;
        _panBeginScaleY = [pan locationInView:_imgView].y / _imgView.frame.size.height;
        
        if (_panBeginScaleX < 0) {
            _panBeginScaleX = 0;
        }else if (_panBeginScaleX > 1) {
            _panBeginScaleX = 1;
        }
        
        if (_panBeginScaleY < 0) {
            _panBeginScaleY = 0;
        }else if (_panBeginScaleY > 1) {
            _panBeginScaleY = 1;
        }
        

    }else if (pan.state == UIGestureRecognizerStateChanged) {

        
        CGFloat tx = point.x;
        CGFloat ty = point.y;
        
        self.imgView.transform = CGAffineTransformScale(self.imgView.transform, scale, scale);
        self.imgView.transform = CGAffineTransformTranslate(self.imgView.transform, tx, ty);
        
        
    }else if (pan.state == UIGestureRecognizerStateEnded) {
        
        
        CGPoint velocity = [pan velocityInView:self.imgView];
        if (velocity.y>200 || (self.view.frame.size.height - self.imgView.frame.origin.y -64)<50) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    [pan setTranslation:CGPointZero inView:self.imgView];
}

- (IBAction)back:(id)sender {
    _ani.isPush = NO;
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
