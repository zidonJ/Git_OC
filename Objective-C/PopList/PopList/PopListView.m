//
//  PopListView.m
//  PopList
//
//  Created by 姜泽东 on 2017/8/31.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "PopListView.h"
#import "LeftImageCell.h"
#import "PopItem.h"

//定义常量 kLeftImagecellId
static NSString *leftImagecellId = @"leftImagecellId";
static NSString *textCellId = @"textCellId";

static NSInteger rowHeight = 44;
static NSInteger cellWidth = 100;

@interface PopListView ()<UITableViewDelegate,UITableViewDataSource>

//属性的注释方法
/**目标控件的point*/
@property (nonatomic,assign) CGPoint point;
/**目标控件的size*/
@property (nonatomic,assign) CGSize gsize;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UIView *maskView;
/**目标控件的父view*/
@property (nonatomic,weak) UIView *tempView;

/**三角形*/
@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation PopListView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self _init];
    }
    return self;
}

#pragma mark -- public func --

- (void)configRect:(CGRect)rect contents:(NSArray *)array view:(UIView *)view
{
    _point = rect.origin;
    _gsize = rect.size;
    _tempView = view;
    NSMutableArray *mutableArray = [@[] mutableCopy];
    for (NSDictionary *dict in array) {
        PopItem *item = [[PopItem alloc] init];
        [item setValuesForKeysWithDictionary:dict];
        [mutableArray addObject:item];
    }
    _dataArray = mutableArray;
    
    [self uiConfig];
}

#pragma mark -- private func --
- (void)_init
{
    _imgView = [UIImageView new];
    _tableView = [[UITableView alloc] init];
    [self makeMaskView];
}

- (void)makeMaskView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *maskView = [UIView new];
    maskView.frame = window.bounds;
    maskView.alpha = 0.4;
    maskView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMask)];
    [maskView addGestureRecognizer:tap];
    [window addSubview:maskView];
    _maskView = maskView;
}

/**
 UI控制
 */
- (void)uiConfig
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44;//iOS11需要指定行高
    [self addSubview:_tableView];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGPoint convert_point = [_tempView convertPoint:_point toView:window];
    
    NSInteger s_width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat x_origin;
    CGFloat y_origin = convert_point.y + _gsize.height;
    
    
    
    UIImage *image = [self makeTriangleImage];
    _imgView.image = image;
    if (convert_point.x + cellWidth/2 >= s_width) {
        x_origin = s_width - cellWidth - 5;
        
    }else if(convert_point.x - cellWidth/2 <= 0){
        x_origin = 5;
    }else {
        x_origin = convert_point.x-cellWidth/2;
    }
    
    
    //这里指考虑了向下展开的情况
    CGFloat height = 20+rowHeight*_dataArray.count;
    _tableView.scrollEnabled = NO;
    if ((height + y_origin) > [[UIScreen mainScreen] bounds].size.height) {
        
        height = [[UIScreen mainScreen] bounds].size.height - y_origin - 44;
        _tableView.scrollEnabled = YES;
    }
    
    self.frame = CGRectMake(x_origin, y_origin, cellWidth, height);
    
    
    CGPoint convert_point_self = [_tempView convertPoint:_point toView:self];
    _imgView.frame = CGRectMake(convert_point_self.x-10, 0, 20, 20);
    if (!_imgView.superview) {
        [self addSubview:_imgView];
    }
    
    if (self.superview) {
        [self show];
    }else{
        [window addSubview:self];
    }
    
    _tableView.frame = CGRectMake(0, 20, self.frame.size.width, height - 20);
    
    [_tableView reloadData];
    
    //按照确定的布局重新画三角
    [self setNeedsDisplay];
    
}

- (UIImage *)makeTriangleImage
{
    UIGraphicsBeginImageContext(CGSizeMake(20, 20));
    
    [[UIColor clearColor] setFill];
    UIRectFill(CGRectMake(0, 0, 20, 20));
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [[UIColor yellowColor] setFill];
    //控制三角形的位置
    [path moveToPoint:CGPointMake(0, 20)];
    [path addLineToPoint:CGPointMake(10, 0)];
    [path addLineToPoint:CGPointMake(20, 20)];
    [path closePath];
    [path fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark -- Action -- 

- (void)tapMask
{
    [self hide];
}

- (void)hide
{
    _maskView.hidden = YES;
    self.hidden = YES;
}

- (void)show
{
    _maskView.hidden = NO;
    self.hidden = NO;
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource --

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftImageCell *cell = [tableView dequeueReusableCellWithIdentifier:leftImagecellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LeftImageCell" owner:nil options:nil] lastObject];
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.item = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.select) {
        self.select(indexPath.row);
    }
    [self hide];
}

@end
