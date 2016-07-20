//
//  QNPlayerView.h
//  AVPlayer0Go
//
//  Created by zidon on 15/11/22.
//  Copyright © 2015年 zidon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class QNPlayerView;

#define Bounds [[UIScreen mainScreen] bounds]

typedef NS_ENUM(NSInteger, QNVideoPlayerPlaybackState) {
    QNVideoPlayerPlaybackStateStopped = 0,//播放结束状态
    QNVideoPlayerPlaybackStatePlaying,//正在播放状态
    QNVideoPlayerPlaybackStatePaused,//暂停播放状态
    QNVideoPlayerPlaybackStateFailed,//播放失败状态(视频损坏或无法识别)
};

@protocol  QNVideoViewDelegate <NSObject>

@optional
//可以播放
- (void)canStartPlaying:(QNPlayerView *)qnVideoView;
//网络状态不可达
- (void)networkNotBest:(QNPlayerView *)qnVideoView;
//播放失败
- (void)failPlayer:(QNPlayerView *)qnVideoView;
//
- (void)bufferTimeLengh:(CGFloat)time;
//时间控制
- (void)currentPlayerTimeLengh:(long)currentTime andTotleTime:(long)totleTime;
//播放结束
- (void)playEnd:(QNPlayerView *)qnVideoView;
//控制播放控件隐藏
-(void)clickPlayerView;

@end

@interface QNPlayerView : UIView

-(id)initWithFrame:(CGRect)frame withContentUrl:(NSString *)url;

//-(instancetype)initWithContentUrl:(NSString *)url;

- (void)seekToTime:(float)time;

- (void)play;
- (void)pause;
- (void)stop;
- (void)repeatPlaying;
- (void)controlPlay;

@property (nonatomic,weak) id<QNVideoViewDelegate> delegate;

@property (nonatomic,assign) QNVideoPlayerPlaybackState playbackState;
//视频播放地址
@property (nonatomic,copy) NSString *contentUrl;
//视频时间相关
@property (nonatomic,assign) long  currentTime;
@property (assign,readonly) long   totalTime;
@property (nonatomic,readonly)CMTimeScale  timeScale;

@property (nonatomic,assign) BOOL moveSlider;


@end
