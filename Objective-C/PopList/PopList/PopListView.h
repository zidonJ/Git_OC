//
//  PopListView.h
//  PopList
//
//  Created by 姜泽东 on 2017/8/31.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectBack)(NSInteger index);

@interface PopListView : UIView

/**选中某个的回调*/
@property (nonatomic,copy) selectBack select;


/**
 配置

 @param rect 目标控件尺寸
 @param array 列表内容
 @param view 目标控件的父view
 */

- (void)configRect:(CGRect)rect contents:(NSArray *)array view:(UIView *)view;


@end
