//
//  QNSliderView.m
//  AVPlayer0Go
//
//  Created by zidon on 15/11/22.
//  Copyright © 2015年 zidon. All rights reserved.
//

#import "QNSliderView.h"
#import "Masonry.h"
#import "ShowProgressView.h"
#import "QNCountTimer.h"

typedef enum : NSUInteger {
    EndInNomal  = 1,
    EndInBeaing = 2,
    EndInEnding
} SliderLocation;

CGSize size;

@interface QNSliderView ()<UIGestureRecognizerDelegate>

@property (nonatomic,assign) float length;
@property (nonatomic,assign) float width;
@property (nonatomic,strong) UIImageView *panImgView;
@property (nonatomic,strong) ShowProgressView *progressView;

@property (nonatomic,assign) float beginX;
@property (nonatomic,assign) float endX;
@property (nonatomic,assign) float changeX;

@property (nonatomic,assign) float currentTranslate;

@property (nonatomic,assign) SliderLocation sliderLocation;

@end

@implementation QNSliderView

-(void)setChangeX:(float)changeX
{
    _panImgView.frame=CGRectMake(changeX, 0, size.width, size.height);
    _changeX=changeX;
}

-(id)init
{
    self=[super init];
    if (self) {
        _beginX=0;
        _currentTranslate=0;
        _changeX=0;
        [self uiconfig];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    size=_panImgView.bounds.size;
    _endX=self.frame.size.width-self.frame.size.height;
}

-(void)uiconfig
{
    _progressView=[[ShowProgressView alloc] init];
    [self addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(2);
    }];
    _progressView.backgroundColor=[UIColor yellowColor];
    
    _panImgView=[[UIImageView alloc] init];
    [self addSubview:_panImgView];
    [_panImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    _panImgView.backgroundColor=[UIColor greenColor];
    _panImgView.userInteractionEnabled=YES;
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImg:)];
    pan.cancelsTouchesInView=NO;
    [_panImgView addGestureRecognizer:pan];
}

-(void)panImg:(UIPanGestureRecognizer *)pan
{
    CGFloat translation;
    CGFloat speedOrientation;
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            [[QNCountTimer sharedInstance] suspend];
            [self.sliderDelegate seekBegan:self];
            _currentTranslate=self.changeX;
            break;
        }
        case UIGestureRecognizerStateChanged:
            translation = [pan translationInView:_panImgView].x;
            speedOrientation=[pan velocityInView:pan.view].x;
            if (translation>_endX) {
                return;
            }
            switch (self.sliderLocation) {
                case EndInBeaing:
                    if (speedOrientation<0) {
                        return;
                    }
                    break;
                case EndInEnding:
                    if (speedOrientation>0) {
                        return;
                    }
                    break;
                    
                default:
                    break;
            }
            if (_panImgView.frame.origin.x>=_beginX&&_panImgView.frame.origin.x<=_endX) {
                [self drawLength:translation+_currentTranslate andHeight:2];
                _panImgView.transform=CGAffineTransformMakeTranslation(translation+_currentTranslate, 0);
            }
            break;
        case UIGestureRecognizerStateEnded:{
            _currentTranslate=_panImgView.transform.tx;
            self.sliderLocation=EndInNomal;
            if (_currentTranslate>=_endX) {
                _currentTranslate=_endX;
                self.sliderLocation=EndInEnding;
            }else if(_currentTranslate<=0){
                _currentTranslate=0;
                self.sliderLocation=EndInBeaing;
            }
            _percentageValue=(float)_currentTranslate/_endX;
            _seekPersent(_percentageValue);
            [self.sliderDelegate seekEnd:self];
            [self.progressView drawLength:_currentTranslate andHeight:2];
            [[QNCountTimer sharedInstance] suspend];
            break;
        }
        case UIGestureRecognizerStatePossible:
            NSLog(@"UIGestureRecognizerStatePossible");
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"UIGestureRecognizerStateCancelled");
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"UIGestureRecognizerStateFailed");
            break;
        default:
            break;
    }
}

-(void)drawLength:(float)LineLength andHeight:(float)lineWidth
{
    self.changeX=LineLength;
    //_panImgView.transform=CGAffineTransformMakeTranslation(_currentTranslate, 0);
    [_progressView drawLength:LineLength andHeight:lineWidth];
}

@end
