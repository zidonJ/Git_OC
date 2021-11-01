//
//  WBLittlePointView.h
//  LittlePoint
//
//  Created by jiangzedong on 2021/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIView (Ex)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (assign, nonatomic) CGFloat   centerX;
@property (assign, nonatomic) CGFloat   centerY;

@end

@interface WBLittlePointView : UIView

@property (nonatomic, copy) void (^reChangeContentHeight) (CGFloat needHeight);

- (void)scrollToTop;
- (void)scrollToDown;


/// 重新布局 并设置选中index
/// @param count 圆点数量
/// @param selectIndex 选中的index 从0开始
- (void)reloadUIWithCount:(NSUInteger)count selectIndex:(NSUInteger)selectIndex;

@end

NS_ASSUME_NONNULL_END
