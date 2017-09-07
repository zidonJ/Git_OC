#pragma mark Forward Declarations


#pragma mark - Protocol

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol MTVCTransitonProtocol<NSObject>


#pragma mark - Required Methods

@required

@property(nonatomic,copy) UIImage *image;
@property(nonatomic,readonly) CGRect imageFrame;
@property(nonatomic,readonly) UIView *imageTargetView;

#pragma mark - Optional Methods

@optional



@end
