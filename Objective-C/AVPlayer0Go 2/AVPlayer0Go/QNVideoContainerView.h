//
//  QNVideoContainerView.h
//  AVPlayer0Go
//
//  Created by zidon on 15/11/25.
//  Copyright © 2015年 zidon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QNVideoContainerView : UIView

-(instancetype)initWithFrame:(CGRect)frame withContentUrl:(NSString *)url;

-(void)controlToPlay;

-(void)controlFullSceen;

-(void)bottomViewShow;

-(void)bottomViewHide;

-(void)stop;

@end
