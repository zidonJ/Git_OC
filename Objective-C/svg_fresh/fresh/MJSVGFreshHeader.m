//
//  MJSVGFreshHeader.m
//  fresh
//
//  Created by zidonj on 2016/12/14.
//  Copyright © 2016年 zidon. All rights reserved.
//

#import "MJSVGFreshHeader.h"
#import "TGDrawSvgPathView.h"

@interface MJSVGFreshHeader ()
{
    CADisplayLink *_displayLink;
}
@property (nonatomic,strong) TGDrawSvgPathView *v;

@property (assign, nonatomic) CGFloat insetTDelta;

@end

@implementation MJSVGFreshHeader

-(instancetype)init
{
    self=[super init];
    if (self) {
        _v=[[TGDrawSvgPathView alloc] initWithFrame:CGRectZero];
        _v.backgroundColor=[UIColor clearColor];
        [self addSubview:_v];
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateSvg)];
        _displayLink.paused=YES;
        _displayLink.preferredFramesPerSecond=1;
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

-(void)configSvgHeader{
    CGRect rect=CGRectMake([[UIScreen mainScreen] bounds].size.width/2-self.frame.size.height/2, 0, self.frame.size.height, self.frame.size.height);
    _v.frame=rect;
    [_v createImageWithPath:@"cloud"];
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    // 在刷新的refreshing状态
    if (self.state == MJRefreshStateRefreshing) {
        if (self.window == nil) return;
        
        // sectionheader停留解决
        CGFloat insetT = - self.scrollView.mj_offsetY > _scrollViewOriginalInset.top ? - self.scrollView.mj_offsetY : _scrollViewOriginalInset.top;
        insetT = insetT > self.mj_h + _scrollViewOriginalInset.top ? self.mj_h + _scrollViewOriginalInset.top : insetT;
        self.scrollView.mj_insetT = insetT;
        
        self.insetTDelta = _scrollViewOriginalInset.top - insetT;
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.mj_offsetY;
    NSLog(@"%f",offsetY);
    
    if (offsetY<0) {
        float left=[[UIScreen mainScreen] bounds].size.width;
        float height=self.mj_h;
        float width=fabs(offsetY);
        if (self.state==MJRefreshStatePulling) {
            return;
        }
        float widthReal=((width>height)?(height):(width))/1.5;
        _v.frame=CGRectMake(left/2-widthReal/2,height-widthReal-5,widthReal,widthReal);
        _v.imgv.frame=_v.frame;
    }

}

-(void)beginRefreshing
{
    [super beginRefreshing];
    _displayLink.paused=NO;
    [self drawSvg];
}

-(void)endRefreshing
{
    [super endRefreshing];
    _displayLink.paused=YES;
    _v.layer.sublayers=nil;
}

#pragma mark -- private func

-(void)drawSvg
{
    [self bringSubviewToFront:_v];
    _v.layer.sublayers=nil;
    [_v setPathFromSvg:@"cloud" strokeColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1] duration:0.5];
}

-(void)updateSvg
{
    [self drawSvg];
}

@end
