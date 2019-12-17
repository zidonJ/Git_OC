//
//  ViewController.m
//  Science
//
//  Created by zidonj on 2018/11/6.
//  Copyright © 2018 langlib. All rights reserved.
//

#import "ViewController.h"
#import "LoopCapture.h"
#import "LBFile.h"
#import <AVFoundation/AVFoundation.h>
#import "LBTimerCutDown.h"

@interface TestTimerVC : UIViewController

@property (nonatomic,copy) NSString *text;

@end


@implementation TestTimerVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"123123123");
        });
    });
    
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    [LBTimerCutDown.shareInstance shareCountDown:^NSInteger{
        return 30;
    } sec:^(NSInteger sec) {
        NSLog(@"%ld",sec);
        __strong typeof(weakSelf) self = weakSelf;
        self.text = [NSString stringWithFormat:@"倒计时：%ld s",sec];
    } complete:^BOOL{
        NSLog(@"倒计时顺利完成");
        return false;
    } withTarget:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)dealloc {
    NSLog(@"顺利释放");
}

@end

@interface ViewController () <UITableViewDataSource,UITableViewDelegate> {
    
    UITableView *_tableView;
    AVPlayer *_player1;
    AVPlayerLayer *_playerLayer1;
    AVPlayerItem *_myPlayerItem1;
}

@end

@implementation ViewController

+ (void)aab {
    
    NSLog(@"12345678909876543");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [self.view addSubview:_tableView];
    [self.view addSubview:_tableView];
    [self.view addSubview:_tableView];
    [self.view addSubview:_tableView];
    
    [[LoopCapture sharedRunLoopWorkDistribution] start];
    
    NSLog(@"主线程栈空间:%lu",NSThread.currentThread.stackSize);
    NSLog(@"主线程栈空间:%.1f",NSThread.currentThread.stackSize/1024/1024.0f);
    
    
    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    v.backgroundColor = [UIColor greenColor];
    v.image = [UIImage imageNamed:@"home_tpo_read_card"];
    v.backgroundColor = [UIColor greenColor];
//    v.layer.cornerRadius = 50;
//    v.layer.masksToBounds = YES;
    [self.view addSubview:v];
    
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = v.bounds;
    shapeLayer.lineWidth = 1;
    shapeLayer.fillColor = [UIColor greenColor].CGColor;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    
    UIBezierPath *berth = [UIBezierPath bezierPathWithRoundedRect:v.bounds
                                                byRoundingCorners:UIRectCornerAllCorners
                                                      cornerRadii:v.frame.size];
    
    shapeLayer.path = berth.CGPath;
    v.layer.mask = shapeLayer;
    //[v.layer addSublayer:shapeLayer];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ResponseChainVC"];
//    [self presentViewController:vc animated:YES completion:nil];
    
    TestTimerVC *test = [[TestTimerVC alloc] init];
    [self presentViewController:test animated:true completion:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *cellText = nil;
    if (indexPath.row%10 == 0) {
        /*
         sleep 执行挂起指定的秒数
         usleep 功能把进程挂起一段时间， 单位是微秒（百万分之一秒） 若想最佳利用cpu，在更小的时间情况下，选择用usleep
         */
        usleep(300*1000);
        cellText = @"我需要一些时间";
    }else {
        cellText = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    }
    cell.textLabel.text = cellText;
    return cell;
}


@end

