//
//  ViewController.m
//  PopList
//
//  Created by 姜泽东 on 2017/8/31.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "ViewController.h"
#import "PopListView.h"

@interface ViewController ()

@property (nonatomic,strong) PopListView *popView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark -- Action --

//超出左边距的情况
- (IBAction)one:(UIButton *)sender {
    
    NSArray *array = @[@{@"image":@"1.jpeg",@"title":@"test1"},
                       @{@"image":@"2.jpeg",@"title":@"test2"},
                       @{@"image":@"3.jpeg",@"title":@"test3"},
                       @{@"image":@"1.jpeg",@"title":@"test1"},
                       @{@"image":@"2.jpeg",@"title":@"test2"},
                       @{@"image":@"1.jpeg",@"title":@"test1"},
                       @{@"image":@"2.jpeg",@"title":@"test2"},
                       @{@"image":@"3.jpeg",@"title":@"test3"},
                       @{@"image":@"1.jpeg",@"title":@"test1"},
                       @{@"image":@"2.jpeg",@"title":@"test2"},
                       @{@"image":@"3.jpeg",@"title":@"test3"}];
    
    [self.popView configRect:CGRectMake(sender.frame.origin.x+sender.frame.size.width/2, sender.frame.origin.y, sender.frame.size.width, sender.frame.size.height) contents:array view:self.view];
    
    self.popView.select = ^(NSInteger index) {
        NSLog(@"%ld",(long)index);
    };
}

//中间的情况
- (IBAction)two:(UIButton *)sender {
    
    
    NSArray *array = @[@{@"image":@"1.jpeg",@"title":@"test1"},
                       @{@"image":@"2.jpeg",@"title":@"test2"},
                       @{@"image":@"3.jpeg",@"title":@"test3"}];
    
    [self.popView configRect:CGRectMake(sender.frame.origin.x+sender.frame.size.width/2, sender.frame.origin.y, sender.frame.size.width, sender.frame.size.height) contents:array view:self.view];
    
    self.popView.select = ^(NSInteger index) {
        NSLog(@"%ld",(long)index);
    };
    
}

//超出右边距的情况,当行数超出屏幕范围，可以滚动
- (IBAction)three:(UIButton *)sender {
    
    NSArray *array = @[@{@"image":@"1.jpeg",@"title":@"test1"},
                       @{@"image":@"2.jpeg",@"title":@"test2"},
                       @{@"image":@"1.jpeg",@"title":@"test1"},
                       @{@"image":@"2.jpeg",@"title":@"test2"},
                       @{@"image":@"3.jpeg",@"title":@"test3"},
                       @{@"image":@"1.jpeg",@"title":@"test1"},
                       @{@"image":@"2.jpeg",@"title":@"test2"},
                       @{@"image":@"1.jpeg",@"title":@"test1"},
                       @{@"image":@"2.jpeg",@"title":@"test2"},
                       @{@"image":@"3.jpeg",@"title":@"test3"},
                       @{@"image":@"1.jpeg",@"title":@"test1"},
                       @{@"image":@"2.jpeg",@"title":@"test2"},
                       @{@"image":@"1.jpeg",@"title":@"test1"},
                       @{@"image":@"2.jpeg",@"title":@"test2"},
                       @{@"image":@"3.jpeg",@"title":@"test3"},
                       @{@"image":@"1.jpeg",@"title":@"test1"},
                       @{@"image":@"2.jpeg",@"title":@"test2"},
                       @{@"image":@"1.jpeg",@"title":@"test1"},
                       @{@"image":@"2.jpeg",@"title":@"test2"},
                       @{@"image":@"3.jpeg",@"title":@"test3"},
                       @{@"image":@"1.jpeg",@"title":@"test1"},
                       @{@"image":@"2.jpeg",@"title":@"test2"},
                       @{@"image":@"3.jpeg",@"title":@"test3"}];
    
    [self.popView configRect:CGRectMake(sender.frame.origin.x+sender.frame.size.width/2, sender.frame.origin.y, sender.frame.size.width, sender.frame.size.height) contents:array view:self.view];
    
    self.popView.select = ^(NSInteger index) {
        NSLog(@"%ld",(long)index);
    };
}

#pragma mark -- setter --

-(PopListView *)popView
{
    if (!_popView) {
        _popView = [[PopListView alloc] init];
    }
    return _popView;
}



@end
