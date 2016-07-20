//
//  QNPlayerBottomView.m
//  AVPlayer0Go
//
//  Created by zidon on 15/11/22.
//  Copyright © 2015年 zidon. All rights reserved.
//

#import "QNPlayerBottomView.h"
#import "QNSliderView.h"
#import "Masonry.h"
#import "QNCountTimer.h"

@interface QNPlayerBottomView ()<QNSliderViewDelegate>

//显示进度,调整进度
@property (nonatomic,strong) UISlider *progressView;
//@property (nonatomic,strong) QNSliderView *progressView;
//显示播放总时间与进行时间
@property (nonatomic,strong) UILabel *visableLable;

@property (nonatomic,strong) QNPlayerView *relatePlayer;

@property (nonatomic,copy) BtnBlock fullBtnBlock;

@property (nonatomic,copy) NSString *currentTime;

@property (nonatomic,copy) NSString *totleTime;

@end

@implementation QNPlayerBottomView

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"hidder"];
}

-(void)setNCurrentTime:(long)nCurrentTime
{
    self.currentTime=[self changeTheTimeToSortWithNSTimeInterval:nCurrentTime];
    self.visableLable.text=[NSString stringWithFormat:@"%@/%@",self.currentTime,self.totleTime];
    _nCurrentTime=nCurrentTime;
    [self makeSliderAsync];
}

-(void)setNTotleTime:(long)nTotleTime
{
    self.totleTime=[self changeTheTimeToSortWithNSTimeInterval:nTotleTime];
    _progressView.maximumValue=nTotleTime;
    _progressView.minimumValue=0;
    _nTotleTime=nTotleTime;
}

-(void)setIsFullScreen:(BOOL)isFullScreen
{
    NSString *title=isFullScreen?@"小屏":@"全屏";
    [self.fullScreenPlay setTitle:title forState:UIControlStateNormal];
    _isFullScreen=isFullScreen;
}

-(void)setIsPlaying:(BOOL)isPlaying
{
    NSString *title=isPlaying?@"暂停":@"播放";
    [self.controlPlayButton setTitle:title forState:UIControlStateNormal];
    _isPlaying=isPlaying;
}

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor purpleColor];
        self.nCurrentTime=0;
        self.nTotleTime=0;
        //[self makeObsverHidder];
        [self uiconfig];
    }
    return self;
}
//监听self的隐藏状态
-(void)makeObsverHidder
{
    [self addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

#pragma mark --UIConfig -
-(void)uiconfig
{
    self.controlPlayButton=[UIButton buttonWithType:UIButtonTypeCustom];
    NSString *title=_relatePlayer.playbackState==QNVideoPlayerPlaybackStatePlaying?@"暂停":@"播放";
    [self.controlPlayButton setTitle:title forState:UIControlStateNormal];
    self.controlPlayButton.titleLabel.font=[UIFont systemFontOfSize:13];
    self.controlPlayButton.backgroundColor=[UIColor redColor];
    [self.controlPlayButton addTarget:self action:@selector(controlPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.controlPlayButton];
    [self.controlPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.leading.equalTo(self).offset(5);
    }];
    
    self.fullScreenPlay=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.fullScreenPlay setTitle:@"全屏" forState:UIControlStateNormal];
    self.fullScreenPlay.titleLabel.font=[UIFont systemFontOfSize:13];
    [self.fullScreenPlay addTarget:self action:@selector(fullScreenPlay:) forControlEvents:UIControlEventTouchUpInside];
    self.fullScreenPlay.backgroundColor=[UIColor orangeColor];
    [self addSubview:self.fullScreenPlay];
    [self.fullScreenPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.centerY.equalTo(self);
    }];
    
    self.progressView=[[UISlider alloc] init];
    [self.progressView setThumbImage:[UIImage imageNamed:@"kr-video-player-point"] forState:UIControlStateNormal];
    [self.progressView setMinimumTrackTintColor:[UIColor whiteColor]];
    [self.progressView setMaximumTrackTintColor:[UIColor lightGrayColor]];
    [self.progressView addTarget:self action:@selector(changeLableTime:) forControlEvents:UIControlEventValueChanged];
    [self.progressView addTarget:self action:@selector(changeSliderBegan:) forControlEvents:UIControlEventTouchDown];
    [self.progressView addTarget:self action:@selector(changeSliderEnd:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressView addTarget:self action:@selector(changeSliderEnd:) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.controlPlayButton.mas_right).offset(6);
        make.height.mas_equalTo(30);
        make.right.equalTo(self.fullScreenPlay.mas_left).offset(-6);
        make.top.mas_equalTo(5);
    }];
    self.progressView.backgroundColor=[UIColor redColor];
    
    self.visableLable=[[UILabel alloc] init];
    self.visableLable.text=[NSString stringWithFormat:@"%@/%@",_currentTime,_totleTime];
    self.visableLable.font=[UIFont systemFontOfSize:12];
    self.visableLable.textColor=[UIColor whiteColor];
    self.visableLable.textAlignment=NSTextAlignmentRight;
    [self addSubview:self.visableLable];
    
    [self.visableLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullScreenPlay.mas_left).offset(-20);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(90);
        make.top.equalTo(self.progressView.mas_bottom).offset(1);
    }];
}
#pragma mark --滚动条控制 -
-(void)changeLableTime:(UISlider *)slider
{
    if (_delegate&&[_delegate respondsToSelector:@selector(seekDraging:andSlider:)]) {
        [_delegate seekDraging:self andSlider:slider.value];
    }
    self.nCurrentTime=slider.value;
}

-(void)changeSliderBegan:(UISlider *)slider
{
    if (_delegate&&[_delegate respondsToSelector:@selector(seekBeganDrag:andSlider:)]) {
        [_delegate seekBeganDrag:self andSlider:slider.value];
    }
}

-(void)changeSliderEnd:(UISlider *)slider
{
    if (_delegate&&[_delegate respondsToSelector:@selector(seekDragEnd:andSlider:)]) {
        [_delegate seekDragEnd:self andSlider:slider.value];
    }
}

//播放按钮
-(void)controlPlay:(UIButton *)play
{
    if (_delegate&&[_delegate respondsToSelector:@selector(playControl:)]) {
        [_delegate playControl:play];
    }
}
//全屏按钮
-(void)fullScreenPlay:(UIButton *)fullScreenPlay
{
    if (_delegate&&[_delegate respondsToSelector:@selector(fullScreenControl:)]) {
        [_delegate fullScreenControl:fullScreenPlay];
    }
}

-(void)clickPlayerView
{
    self.hidden=!self.hidden;
}

//将时间秒转换成时分秒格式(int类型)
-(NSString *)changeTheTimeToSortWithNSTimeInterval:(long)time
{
    int sec = time%60;
    int min = (time/60)%60;
    //int hour = time/(60*60);
    NSString *sortTime = [NSString stringWithFormat:@"%.2d:%.2d",min,sec];
    return sortTime;
}
//横竖屏的block调用
-(void)getFullBtnBlock:(BtnBlock)fullBtnBlock
{
    _fullBtnBlock = fullBtnBlock;
}
//时间控制器调用
-(void)makeTimer
{
    __weak typeof(self) wself=self;
    [[QNCountTimer sharedInstance] timeControl:^{
        wself.hidden=YES;
        [[QNCountTimer sharedInstance] suspend];
        [wself makeObsverHidder];
    }];
}

-(void)makeSliderAsync
{
    NSLog(@"%ld",self.nCurrentTime);
    _progressView.value=self.nCurrentTime;
}

#pragma mark --KVO -
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([change[@"new"] intValue]==0) {
        //显示状态,需要时间控制器去隐藏
        [[QNCountTimer sharedInstance] resume];
    }else{
        [[QNCountTimer sharedInstance] suspend];
    }
}

@end
