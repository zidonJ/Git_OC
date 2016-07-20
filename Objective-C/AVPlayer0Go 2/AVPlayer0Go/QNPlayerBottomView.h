//
//  QNPlayerBottomView.h
//  AVPlayer0Go
//
//  Created by zidon on 15/11/22.
//  Copyright © 2015年 zidon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QNPlayerView.h"

typedef void(^BtnBlock) ();

@class QNPlayerBottomView;

@protocol QNPlayerBottomViewDelegate <NSObject>

@optional
//开始拖动进度条
-(void)seekBeganDrag:(QNPlayerBottomView *)sliderView andSlider:(float)sliderValue;
//拖动中
-(void)seekDraging:(QNPlayerBottomView *)sliderView andSlider:(float)sliderValue;
//结束拖动进度条
-(void)seekDragEnd:(QNPlayerBottomView *)sliderView andSlider:(float)sliderValue;

-(void)playControl:(UIButton *)playBtn;

-(void)fullScreenControl:(UIButton *)fullScreenBtn;

@end

@interface QNPlayerBottomView : UIView<QNVideoViewDelegate>

//播放暂停按钮
@property (nonatomic,strong) UIButton *controlPlayButton;
//全屏播放按钮
@property (nonatomic,strong) UIButton *fullScreenPlay;

-(id)initWithFrame:(CGRect)frame;

-(void)getFullBtnBlock:(BtnBlock)fullBtnBlock;

@property (nonatomic,assign) long nCurrentTime;

@property (nonatomic,assign) long nTotleTime;

@property (nonatomic,weak) id<QNPlayerBottomViewDelegate> delegate;

@property (nonatomic,assign) BOOL isFullScreen;

@property (nonatomic,assign) BOOL isPlaying;

@end
