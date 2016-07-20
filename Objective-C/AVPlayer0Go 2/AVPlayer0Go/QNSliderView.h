//
//  QNSliderView.h
//  AVPlayer0Go
//
//  Created by zidon on 15/11/22.
//  Copyright © 2015年 zidon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QNSliderView;

typedef void(^sendSeekValue)(float seekPercentage);

@protocol QNSliderViewDelegate <NSObject>

@optional
-(void)seekBegan:(QNSliderView *)sliderView;

-(void)seekEnd:(QNSliderView *)sliderView;

@end

@interface QNSliderView : UIView

-(void)drawLength:(float)LineLength andHeight:(float)lineWidth;

@property (nonatomic,assign) float maxValue;
@property (nonatomic,assign) float minValue;

@property (nonatomic,assign) float percentageValue;

@property (nonatomic,weak) id<QNSliderViewDelegate> sliderDelegate;

@property (nonatomic,copy) sendSeekValue seekPersent;

@end
