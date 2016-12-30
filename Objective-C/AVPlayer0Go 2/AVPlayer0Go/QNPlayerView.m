//
//  QNPlayerView.m
//  AVPlayer0Go
//
//  Created by zidon on 15/11/22.
//  Copyright © 2015年 zidon. All rights reserved.
//

void *QNPlayer =&QNPlayer;

#import "QNPlayerView.h"

@interface QNPlayerView ()
{
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    AVURLAsset *_movieAsset;
    UIImageView *_imageView;
}

@property (nonatomic,assign) CGRect saveRect;

@end

@implementation QNPlayerView

-(void)dealloc
{
    [_player removeObserver:self forKeyPath:@"rate"];
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

-(id)initWithFrame:(CGRect)frame withContentUrl:(NSString *)url
{
    self=[super initWithFrame:frame];
    if (self) {
        _saveRect = frame;
        _imageView=[[UIImageView alloc] initWithFrame:self.bounds];
        //[self addSubview:_imageView];
        [self setContentUrl:url];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(visiableBottomView:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

//UIView可以选择不同的Layer来呈现,这里选择视频的Layer
+ (Class)layerClass{
    return [AVPlayerLayer class];
}

- (void)setPlayer:(AVPlayer *)player{
    AVPlayerLayer *layer = (AVPlayerLayer *)self.layer;
    layer.needsDisplayOnBoundsChange = YES;
    self.layer.needsDisplayOnBoundsChange = YES;
    [layer setPlayer:player];
}

- (void)setContentUrl:(NSString *)contentUrl
{
    if (!contentUrl||[contentUrl length] == 0){
        return;
    }
    
    NSURL *videoURL = [NSURL URLWithString:contentUrl];
    if (!videoURL || ![videoURL scheme]){
        videoURL = [NSURL fileURLWithPath:contentUrl];
    }
    
    _movieAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    [self setAssert:_movieAsset];
    
    _contentUrl = contentUrl;
}

//设置资源
- (void)setAssert:(AVURLAsset *)assert
{
    __weak typeof(self) weakSelf=self;
    [assert loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
        _playerItem = [AVPlayerItem playerItemWithAsset:assert];
        _player =[AVPlayer playerWithPlayerItem:_playerItem];
        [self setPlayer:_player];
        AVPlayerLayer * playerLayer =[self _setVideoModel:_player];
        //playerLayer.frame=self.frame;
        
        [_player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:QNPlayer];
        
        [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        
        [[NSNotificationCenter  defaultCenter] addObserver:weakSelf  selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [weakSelf.layer addSublayer:playerLayer];
    }];
    
}

- (NSTimeInterval)availableDuration
{
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}

#pragma mark --通知 监听--
//播放结束
-(void)moviePlayDidEnd:(NSNotification *)noty
{
    _playbackState=QNVideoPlayerPlaybackStateStopped;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(playEnd:)]) {
        [self.delegate playEnd:self];
    }
    [_player seekToTime:kCMTimeZero];
}

- (void)monitoringPlayback:(AVPlayerItem *)playerItem
{
    __weak typeof(_delegate) wdelegate=_delegate;
    __weak typeof(self) wself=self;
    id  obj = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time)
               {
                   CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;
                   wself.currentTime = currentSecond;
                   if ([wdelegate respondsToSelector:@selector(currentPlayerTimeLengh:andTotleTime:)])
                   {
                        [wdelegate  currentPlayerTimeLengh:currentSecond
                                              andTotleTime:wself.totalTime];
                   }
                   
               }];
    if (obj) {
        return;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"]){
        if ([playerItem status] == AVPlayerStatusReadyToPlay){
            
            [_player pause];
            _timeScale = playerItem.currentTime.timescale;
            //[self videoImage:CMTimeMake(0, _timeScale)];
            CMTime duration = _player.currentItem.duration;
            _totalTime=(long)CMTimeGetSeconds(duration);//总时间
            
            if ([_delegate respondsToSelector:@selector(canStartPlaying:)]){
                [_delegate canStartPlaying:self];
            }
            _playbackState =QNVideoPlayerPlaybackStatePaused;
            
            [self monitoringPlayback:_player.currentItem];
            
        } else if ([playerItem status] == AVPlayerStatusFailed){
            if ([_delegate respondsToSelector:@selector(failPlayer:)]){
                [_delegate failPlayer:self];
            }
        }
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        //缓冲的时间,以后可能会用到
        NSTimeInterval timeInterval = [self availableDuration];
        if ([_delegate respondsToSelector:@selector(bufferTimeLengh:)]){
            [_delegate bufferTimeLengh:timeInterval];
        }
        
        int rate =[[NSString stringWithFormat:@"%f",_player.rate] intValue];
        NSLog(@"%d",rate);
        //网络状况不好
        if (_playbackState==QNVideoPlayerPlaybackStatePlaying&&rate==0){
            if ([_delegate respondsToSelector:@selector(networkNotBest:)]){
                [_delegate networkNotBest:self];
            }
            if (timeInterval >_currentTime+2) {
                [_player play];
            }
        }
    }
}
//获取视频某处图片
-(UIImage *)videoImage:(CMTime)time
{
    //Float64 durationSeconds = CMTimeGetSeconds([avAsset duration]);
    
    NSError *error;
    CMTime actualTime;
    
    AVAssetImageGenerator *imageGenerator =
    [AVAssetImageGenerator assetImageGeneratorWithAsset:_movieAsset];
    //        [imageGenerator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:CMTimeMakeWithSeconds(0, 600)]] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
    //
    //        }];
    imageGenerator.appliesPreferredTrackTransform = YES;//提取视频的图片资源，默认为no
    CGImageRef imgRef=[imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImageOrientation oreation=UIImageOrientationUp;
    UIImage *frameImage=[UIImage imageWithCGImage:imgRef scale:1 orientation:oreation];
    
    if (self.delegate) {
        [self.delegate backFrameImage:frameImage];
    }
    //播放器会自动加载第一贞的图片，如果没有加载可以在这里操作
    if ([[NSValue valueWithCMTime:time] isEqualToValue:[NSValue valueWithCMTime:CMTimeMake(0, _timeScale)]]) {
        _imageView.image=frameImage;
    }
    
    return frameImage;
}

- (AVPlayerLayer*)_setVideoModel:(AVPlayer *)player
{
    AVPlayerLayer *playerLayer =[AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    [playerLayer setPlayer:player];
    return playerLayer;
}

-(void)visiableBottomView:(UITapGestureRecognizer *)tap
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickPlayerView)]) {
        [self.delegate clickPlayerView];
    }
}

#pragma mark --播放控制--

- (void)controlPlay
{
    switch (_playbackState) {
        case QNVideoPlayerPlaybackStatePlaying:
            [self pause];
            break;
        case QNVideoPlayerPlaybackStatePaused:
            [self play];
            break;
        case QNVideoPlayerPlaybackStateStopped:
            [self repeatPlaying];
            break;
        case QNVideoPlayerPlaybackStateFailed:
            NSLog(@"视频资源不可用");
            break;
        
        default:
            break;
    }
}

- (void)play
{
    [_player play];
    _playbackState=QNVideoPlayerPlaybackStatePlaying;
}

- (void)pause
{
    [_player pause];
    _playbackState =QNVideoPlayerPlaybackStatePaused;
}

-(void)stop
{
    [_player removeObserver:self forKeyPath:@"rate"];
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_player replaceCurrentItemWithPlayerItem:nil];
}

-(void)repeatPlaying
{
    [_player seekToTime:kCMTimeZero];
    [self play];
}

-(void)seekToTime:(float)time
{
    CMTime cmTime = CMTimeMakeWithSeconds(ceil(time), _timeScale);
    
    if (CMTIME_IS_INVALID(cmTime) || _player.currentItem.status != AVPlayerStatusReadyToPlay)
    {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [_player seekToTime:cmTime completionHandler:^(BOOL finished) {
            //self.moveSlider=NO;
            NSLog(@"调整播放时间");
        }];
    });
}

-(UIImage *)getFrameImageWithCMTime:(CMTime)time
{
    return [self videoImage:time];
}

-(UIImage *)getFrameImageWithSecond:(float)time
{
    CMTime cTime = CMTimeMakeWithSeconds(time, _timeScale);
    return [self videoImage:cTime];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame=self.bounds;
}

@end
