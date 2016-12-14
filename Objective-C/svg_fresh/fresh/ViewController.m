//
//  ViewController.m
//  fresh
//
//  Created by zidonj on 2016/12/12.
//  Copyright © 2016年 zidon. All rights reserved.
//

#import "ViewController.h"
#import "MJRefreshHeader.h"
#import "MJRefreshNormalHeader.h"
#import "TGDrawSvgPathView.h"
#import "MJSVGFreshHeader.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshHeaderDelegate>

@property (nonatomic,weak) IBOutlet UITableView *tableview;

@property (nonatomic,strong) TGDrawSvgPathView *v;

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableview.mj_header = [MJSVGFreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [(MJSVGFreshHeader *)self.tableview.mj_header configSvgHeader];
//    CGRect rect=CGRectMake([[UIScreen mainScreen] bounds].size.width/2-self.tableview.mj_header.frame.size.height/2, 0, self.tableview.mj_header.frame.size.height, self.tableview.mj_header.frame.size.height);
//    _v=[[TGDrawSvgPathView alloc] initWithFrame:rect];
//    _v.backgroundColor=[UIColor clearColor];
//    [self.tableview.mj_header addSubview:_v];
//    [_v createImageWithPath:@"cloud"];
//    [_v setPathFromSvg:@"cloud" strokeColor:[UIColor blackColor] duration:1];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    self.tableview.mj_header.automaticallyChangeAlpha = YES;

    // 马上进入刷新状态
//  [self.tableview.mj_header beginRefreshing];
}

-(void)didscroll:(CGFloat)ypdd
{
    NSLog(@"%f",ypdd);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0) {
//        float left=[[UIScreen mainScreen] bounds].size.width;
//        float height=self.tableview.mj_header.frame.size.height;
//        float width=fabs(scrollView.contentOffset.y);
//        if (self.tableview.mj_header.state==MJRefreshStatePulling) {
//            return;
//        }
//        float widthReal=((width>height)?(height):(width))/1.5;
//        _v.frame=CGRectMake(left/2-widthReal/2,height-widthReal,widthReal,widthReal);
//        _v.imgv.frame=_v.frame;
    }
}

-(void)loadNewData
{
//    [self.tableview.mj_header bringSubviewToFront:_v];
//    [_v setPathFromSvg:@"cloud" strokeColor:[UIColor blueColor] duration:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview.mj_header endRefreshing];
//        _v.layer.sublayers=nil;
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"fresh";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}


@end
