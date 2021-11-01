//
//  WBLittlePointView.m
//  LittlePoint
//
//  Created by jiangzedong on 2021/10/29.
//

#import "WBLittlePointView.h"

CGFloat const kStepPointAnimationDuration = 0.25;
CGFloat const kPointWidth = 10.0;
CGFloat const kPointHeight = 10.0;
CGFloat const kPointSelectHeight = 20.0;
CGFloat const kPointTopBottomInset = 5.0;
CGFloat const kPointSpace = 10.0;

typedef NS_ENUM(NSUInteger, WBPointViewType) {
    WBPointViewTypeOver5,
    WBPointViewTypeBelow5
};

@interface WBRealPointView : UIView

@property (nonatomic, assign) NSInteger index;

@end

@implementation WBRealPointView

@end

@interface WBLittlePointView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray<WBRealPointView *> *indicators;
@property (nonatomic, strong) NSMutableArray<NSValue *> *indicatorFrames;
@property (nonatomic, assign) WBPointViewType type;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat needHeight;

@end

@implementation WBLittlePointView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _indicators = NSMutableArray.array;
        _indicatorFrames = NSMutableArray.array;
        [self uiCongfig];
    }
    return self;
}

- (void)uiCongfig
{
    self.backgroundColor = UIColor.greenColor;
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    _contentView.backgroundColor = UIColor.redColor;
    [self addSubview:_contentView];
}

- (void)reset
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_indicators removeAllObjects];
    [_indicatorFrames removeAllObjects];
}

- (void)reloadUIWithCount:(NSUInteger)count selectIndex:(NSUInteger)selectIndex
{
    [self reset];
    CGFloat TopHeight = 0.0;
    CGFloat topInset = 0;
    self.selectIndex = selectIndex;
    if (count <= 5) {
        self.type = WBPointViewTypeBelow5;
        
        for (int i = 0; i<count; i++) {
            topInset = i==0 ? kPointTopBottomInset:0;
            CGFloat width = kPointWidth;
            CGFloat height = kPointHeight;
            if (i == selectIndex) {
                height = kPointSelectHeight;
            }
            WBRealPointView *v = [[WBRealPointView alloc] initWithFrame:CGRectMake((self.width - width)/2, topInset+TopHeight+(i==0?0:kPointSpace), width, height)];
            v.layer.cornerRadius = width/2;
            v.layer.masksToBounds = YES;
            v.backgroundColor = UIColor.whiteColor;
            v.index = i;
            [_contentView addSubview:v];
            [_indicators addObject:v];
            [_indicatorFrames addObject:[NSValue valueWithCGRect:v.frame]];
            TopHeight = CGRectGetMaxY(v.frame);
        }
    } else {
        self.type = WBPointViewTypeOver5;
        self.count = count;
        for (int i = 0; i<7; i++) {
            topInset = i==0 ? kPointTopBottomInset:0;
            CGFloat width = (1-(ABS(4-(i+1)))*0.25)*kPointWidth;
            CGFloat height = (1-(ABS(4-(i+1)))*0.25)*kPointHeight;
            if (i == 3) {
                width = kPointWidth;
                height = kPointSelectHeight;
            }
            WBRealPointView *v = [[WBRealPointView alloc] initWithFrame:CGRectMake((self.width - width)/2, topInset+TopHeight+(i==0?0:kPointSpace), width, height)];
            v.layer.cornerRadius = width/2;
            v.layer.masksToBounds = YES;
            v.backgroundColor = UIColor.whiteColor;
            v.index = i;
            if (selectIndex < 3) {
                v.alpha = (i<=2-selectIndex) ? 0:1;
            } else {
                if (count - selectIndex <= 3) {
                    v.alpha = (i >= (6 - 2 + (count - 1 - selectIndex))) ? 0:1;
                }
            }
            [_contentView addSubview:v];
            [_indicators addObject:v];
            [_indicatorFrames addObject:[NSValue valueWithCGRect:v.frame]];
            TopHeight = CGRectGetMaxY(v.frame);
        }
    }
    TopHeight += kPointTopBottomInset;
    _contentView.frame = CGRectMake(0, 0, self.width, TopHeight);
    self.height = TopHeight;
    !self.reChangeContentHeight?:self.reChangeContentHeight(TopHeight);
}

- (void)disposeIndicatorsFrame
{
    [_indicators sortUsingComparator:^NSComparisonResult(WBRealPointView *  _Nonnull obj1, WBRealPointView *  _Nonnull obj2) {
        if (obj1.index > obj2.index) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    [_indicatorFrames removeAllObjects];
    [_indicators enumerateObjectsUsingBlock:^(WBRealPointView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.indicatorFrames addObject:[NSValue valueWithCGRect:obj.frame]];
    }];
    
    if (self.count - self.selectIndex < 4) {
        NSInteger difference = self.count - self.selectIndex - 1;
        [self.indicators enumerateObjectsUsingBlock:^(WBRealPointView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >= 6 - 2 + difference) {
                obj.alpha = 0;
            } else {
                obj.alpha = 1;
            }
        }];
    }
    if (self.selectIndex < 3) {
        [self.indicators enumerateObjectsUsingBlock:^(WBRealPointView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx <= 2-self.selectIndex) {
                obj.alpha = 0;
            } else {
                obj.alpha = 1;
            }
        }];
    }
}

- (void)scrollToTop
{
    if (self.type == WBPointViewTypeOver5) {
        if (self.selectIndex>=_count-1) {
            return;
        }
        
        [_indicators enumerateObjectsUsingBlock:^(WBRealPointView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WBRealPointView *firstView;
            if (idx == 0) {
                firstView = obj;
                firstView.alpha = 0;
                firstView.frame = _indicators.lastObject.frame;
            }
            if (idx + 1 >= self.indicators.count) {
                return;
            }
            
            WBRealPointView *nextView = self.indicators[idx+1];
            nextView.index -= 1;
            CGRect toFrame = [self.indicatorFrames[idx] CGRectValue];
            
            [UIView animateWithDuration:kStepPointAnimationDuration animations:^{

                nextView.layer.cornerRadius = toFrame.size.width/2;
                nextView.frame = toFrame;
                firstView.alpha = 1;
            }];
        }];
        self.selectIndex += 1;
        _indicators.firstObject.index = _indicators.count - 1;
        [self disposeIndicatorsFrame];
    } else {
        
        WBRealPointView *currentView = self.indicators[self.selectIndex];
        CGFloat currentHeight = currentView.height;
        
        if (self.selectIndex + 1 >= self.indicators.count) {
            return;
        }
        
        WBRealPointView *toView = self.indicators[self.selectIndex+1];
        CGFloat toHeight = toView.height;
        
        [UIView animateWithDuration:kStepPointAnimationDuration animations:^{
            currentView.height = toHeight;
            toView.y = currentView.bottom + 10;
            toView.height = currentHeight;
        }];
        self.selectIndex += 1;
    }
}

- (void)scrollToDown
{
    if (self.type == WBPointViewTypeBelow5) {
        WBRealPointView *currentView = self.indicators[self.selectIndex];
        CGFloat currentHeight = currentView.height;
        
        if (self.selectIndex - 1 < 0) {
            return;
        }
        
        WBRealPointView *toView = self.indicators[self.selectIndex-1];
        CGFloat toHeight = toView.height;
        
        [UIView animateWithDuration:kStepPointAnimationDuration animations:^{
            toView.height = currentHeight;
            currentView.height = toHeight;
            currentView.y = toView.bottom + 10;
        }];
        self.selectIndex -= 1;
    } else {
        if (self.selectIndex <= 0) {
            return;
        }
        NSArray<WBRealPointView *> *reverseArray = _indicators.reverseObjectEnumerator.allObjects;
        NSArray<NSValue *> *reverseFrames = _indicatorFrames.reverseObjectEnumerator.allObjects;
        [reverseArray enumerateObjectsUsingBlock:^(WBRealPointView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            WBRealPointView *firstView;
            if (idx == 0) {
                firstView = obj;
                firstView.alpha = 0;
                firstView.frame = reverseArray.lastObject.frame;
            }
            if (idx + 1 >= reverseArray.count) {
                return;
            }
            
            WBRealPointView *beforeView = reverseArray[idx+1];
            beforeView.index += 1;
            CGRect toFrame = [reverseFrames[idx] CGRectValue];
            
            [UIView animateWithDuration:kStepPointAnimationDuration animations:^{
                beforeView.layer.cornerRadius = toFrame.size.width/2;
                beforeView.frame = toFrame;
                firstView.alpha = 1;
            }];
        }];
        self.selectIndex -= 1;
        _indicators.lastObject.index = 0;
        [self disposeIndicatorsFrame];
    }
    
}

@end

@implementation UIView (Ex)
//重写x属性的 getter方法，返回控件的x值
- (CGFloat)x{
    return self.frame.origin.x;
}
//重写x属性的 setter方法  设置控件的x值
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom{
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}



- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

@end

