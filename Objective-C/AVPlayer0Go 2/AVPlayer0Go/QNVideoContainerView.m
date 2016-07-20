//
//  QNVideoContainerView.m
//  AVPlayer0Go
//
//  Created by zidon on 15/11/25.
//  Copyright © 2015年 zidon. All rights reserved.
//

#import "QNVideoContainerView.h"
#import "QNPlayerView.h"
#import "QNPlayerBottomView.h"
#import "Masonry.h"

typedef enum : NSUInteger {
    Portrait = 0,
    Right,
    Left,
    UpSideAndDown,
} ScreenOreation;


@interface QNVideoContainerView ()<QNVideoViewDelegate,QNPlayerBottomViewDelegate>

@property (nonatomic,strong) QNPlayerView *playerView;
@property (nonatomic,strong) QNPlayerBottomView *bottomView;
@property (nonatomic,copy) NSString *contentUrl;
@property (nonatomic,assign) CGRect originalRect;
//屏幕方向
@property (nonatomic,assign) ScreenOreation oreation;
@property (nonatomic,assign) NSInteger screenInt;

@property (nonatomic,assign) BOOL screenFull;

@end

@implementation QNVideoContainerView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(id)initWithFrame:(CGRect)frame withContentUrl:(NSString *)url
{
    self=[super initWithFrame:frame];
    if (self) {
        _contentUrl=url;
        self.originalRect= frame;
        [self setUpNotification];
        
        [self uiconfig];
    }
    return self;
}

-(void)setUpNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)onDeviceOrientationChange
{
    _screenInt++;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            self.oreation=Portrait;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            self.oreation=Left;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            self.oreation=UpSideAndDown;
            break;
        case UIInterfaceOrientationLandscapeRight:
            self.oreation=Right;
            break;
        default:
            break;
    }
    [self fullScreen:self.oreation];
}

-(void)uiconfig
{
    self.playerView=[[QNPlayerView alloc] initWithFrame:CGRectZero withContentUrl:_contentUrl];
    self.playerView.backgroundColor=[UIColor blueColor];
    self.playerView.delegate=self;
    [self addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self).offset(0);
    }];
    
    self.bottomView=[[QNPlayerBottomView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-40, self.bounds.size.width, 50)];
    self.bottomView.delegate=self;
    [self addSubview:self.bottomView];
}

-(void)fullScreen:(ScreenOreation)oreation
{
    CGRect bounds=[[UIScreen mainScreen] bounds];
    CGRect rect=CGRectMake(0, 0, bounds.size.width, bounds.size.height);
        switch (self.oreation) {
            case Left:{
                [self statusBarHidden:YES];
                _screenFull=YES;
                [UIView animateWithDuration:0.1 animations:^{
                    self.transform=CGAffineTransformMakeRotation(M_PI_2*3);
                    self.frame=rect;
                    self.bottomView.frame = CGRectMake(0, self.bounds.size.height-50, self.bounds.size.width, 50);
                } completion:^(BOOL finished) {
                    self.playerView.frame=self.bounds;
                    [self.bottomView.fullScreenPlay setTitle:@"小屏" forState:UIControlStateNormal];
                }];
                break;
            }
            case Right:{
                [self statusBarHidden:YES];
                _screenFull=YES;
                [UIView animateWithDuration:0.1 animations:^{
                    self.transform=CGAffineTransformMakeRotation(M_PI_2);
                    self.frame=rect;
                    self.bottomView.frame = CGRectMake(0, self.bounds.size.height-50, self.bounds.size.width, 50);
                } completion:^(BOOL finished) {
                    self.playerView.frame=self.bounds;
                    [self.bottomView.fullScreenPlay setTitle:@"小屏" forState:UIControlStateNormal];
                }];
                break;
            }
            case Portrait:{
                [self statusBarHidden:NO];
                [UIView animateWithDuration:0.1 animations:^{
                    if (_screenInt>2) {
                        self.transform=CGAffineTransformMakeRotation(0);
                        self.frame=self.originalRect;
                        self.bottomView.frame = CGRectMake(0, self.bounds.size.height-50, self.bounds.size.width, 50);
                    }
                } completion:^(BOOL finished) {
                    self.playerView.frame=self.bounds;
                    [self.bottomView.fullScreenPlay setTitle:@"全屏" forState:UIControlStateNormal];
                }];
                break;
            }
            case UpSideAndDown:{

                break;
            }
            default:
                break;
        }
}

-(void)statusBarHidden:(BOOL)hiddenBool
{
    [UIApplication sharedApplication].statusBarHidden = hiddenBool;
}

-(void)controlToPlay
{
    [self.playerView controlPlay];
}

-(void)stop
{
    [self.playerView stop];
}

-(void)controlFullSceen
{
    CGRect bounds=[[UIScreen mainScreen] bounds];
    CGRect rect=CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    if (_screenFull) {
        [self statusBarHidden:NO];
        [UIView animateWithDuration:0.1 animations:^{
            self.transform=CGAffineTransformMakeRotation(0);
            self.frame=self.originalRect;
            self.bottomView.frame = CGRectMake(0, self.bounds.size.height-50, self.bounds.size.width, 50);
        } completion:^(BOOL finished) {
            self.playerView.frame=self.bounds;
        }];
    }else{
        [self statusBarHidden:YES];
        [UIView animateWithDuration:0.1 animations:^{
            self.transform=CGAffineTransformMakeRotation(M_PI_2*3);
            self.frame=rect;
            self.bottomView.frame = CGRectMake(0, self.bounds.size.height-50, self.bounds.size.width, 50);
        } completion:^(BOOL finished) {
            self.playerView.frame=self.bounds;
        }];
    }
    _screenFull=!_screenFull;
}

-(void)bottomViewShow
{
    self.bottomView.hidden=YES;
}

-(void)bottomViewHide
{
    self.bottomView.hidden=NO;
}

#pragma mark --QNVideoViewDelegate -
//播放时间
-(void)currentPlayerTimeLengh:(long)currentTime andTotleTime:(long)totleTime
{
    _bottomView.nCurrentTime=currentTime;
}
//网络状况不好,缓冲比较慢
-(void)networkNotBest:(QNPlayerView *)qnVideoView
{
    
}

//播放结束
-(void)playEnd:(QNPlayerView *)qnVideoView
{
    _playerView.playbackState=QNVideoPlayerPlaybackStatePaused;
    _bottomView.isPlaying=NO;
}

-(void)canStartPlaying:(QNPlayerView *)qnVideoView
{
    _bottomView.nTotleTime=(long)ceil(qnVideoView.totalTime);
}

-(void)clickPlayerView
{
    _bottomView.hidden=!_bottomView.hidden;
}

#pragma mark --QNPlayerBottomViewDelegate -

-(void)playControl:(UIButton *)playBtn
{
    switch (_playerView.playbackState) {
        case QNVideoPlayerPlaybackStateStopped:
            _bottomView.isPlaying=NO;
            break;
        case QNVideoPlayerPlaybackStatePlaying:
            [_playerView pause];
            break;
        case QNVideoPlayerPlaybackStatePaused:
            [_playerView play];
            break;
        case QNVideoPlayerPlaybackStateFailed:
            NSLog(@"视频资源不可用");
            break;
            
        default:
            break;
    }
    _bottomView.isPlaying=_playerView.playbackState==QNVideoPlayerPlaybackStatePlaying?YES:NO;
}

-(void)fullScreenControl:(UIButton *)fullScreenBtn
{
    [self controlFullSceen];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _bottomView.isFullScreen=_screenFull;
    });
}

-(void)seekBeganDrag:(QNPlayerBottomView *)sliderView andSlider:(float)sliderValue
{
    [_playerView pause];
}

-(void)seekDraging:(QNPlayerBottomView *)sliderView andSlider:(float)sliderValue{}

-(void)seekDragEnd:(QNPlayerBottomView *)sliderView andSlider:(float)sliderValue
{
    [_playerView seekToTime:sliderValue];
    [_playerView play];
}

@end
