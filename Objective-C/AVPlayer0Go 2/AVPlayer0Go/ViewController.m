//
//  ViewController.m
//  AVPlayer0Go
//
//  Created by zidon on 15/11/22.
//  Copyright © 2015年 zidon. All rights reserved.
//

#import "ViewController.h"
#import "QNPlayerView.h"
#import "QNSliderView.h"
#import "QNPlayerBottomView.h"
#import "Masonry.h"
#import "QNVideoContainerView.h"


static NSString * const VideoUrl = @"http://mami.wxwork.cn//public//js//test1.mp4";

//http://cdn.ali.video.headlines.ahameet.com/video/5804938ebb8b4d51b6f8b51e
//http://krtv.qiniudn.com/150522nextapp
static NSString * const testUrl = @"https://a-pubres-cet.langlib.com/foreign/tpo/TPO-053/listening/TPO-053L1.mp3";



@interface ViewController ()

@property (nonatomic,strong) QNPlayerView *playerView;

@property (nonatomic,strong) UIButton *playButton;
@property (nonatomic,strong) UIButton *fullScreenButton;

@property (nonatomic,strong) UISlider *sliderVideo;

@property (nonatomic,strong) QNSliderView *sliderTest;

@property (nonatomic,strong) QNPlayerBottomView *bottomView;

@property (nonatomic,strong) QNVideoContainerView *videoView;

//@property (nonatomic,assign) ScreenOreation oreation;

@property (nonatomic,assign) CGRect saveRect;

@property (nonatomic,assign) NSInteger screenInt;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.playerView=[[QNPlayerView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 200) withContentUrl:VideoUrl];
//    [self.view addSubview:self.playerView];
    
    self.saveRect=self.playerView.frame;
    
    self.playButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.frame=CGRectMake(0, 30, 60, 30);
    [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    self.playButton.backgroundColor=[UIColor grayColor];
    [self.view addSubview:self.playButton];
    
    self.fullScreenButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.fullScreenButton.frame=CGRectMake(100, 230, 60, 30);
    [self.fullScreenButton setTitle:@"全屏" forState:UIControlStateNormal];
//    [self.fullScreenButton addTarget:self action:@selector(fullScreenMake) forControlEvents:UIControlEventTouchUpInside];
    self.fullScreenButton.backgroundColor=[UIColor grayColor];
    //[self.view addSubview:self.fullScreenButton];
    
    
//    self.sliderVideo=[[UISlider alloc] initWithFrame:CGRectMake(10, 270, 250, 30)];
//    [self.sliderVideo addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
//    
//    self.sliderVideo.minimumValue = 0.0;
//    self.sliderVideo.maximumValue = 1.0;
//    self.sliderVideo.value = 0.0;
//    [self.view addSubview:self.sliderVideo];
    
//    self.sliderTest=[[QNSliderView alloc] initWithFrame:CGRectMake(10, 320, 300, 16)];
//    self.sliderTest.backgroundColor=[UIColor lightGrayColor];
//    [self.sliderTest drawLength:0 andHeight:2];
//    [self.view addSubview:self.sliderTest];
    
    self.bottomView=[[QNPlayerBottomView alloc] initWithFrame:CGRectMake(10, 380, 300, 40)];
    [self.view addSubview:self.bottomView];
    
    self.videoView=[[QNVideoContainerView alloc] initWithFrame:CGRectMake(10, 150, 300, 300) withContentUrl:testUrl];
    self.videoView.backgroundColor=[UIColor greenColor];
    [self.view addSubview:self.videoView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


-(void)change:(UISlider *)slider
{
    [self.sliderTest drawLength:slider.value*300 andHeight:2];
}


-(void)play
{
    [self.videoView stop];
    //[self.playerView controlPlay];
}

@end
