//
//  LeftTableViewCell.h
//  MyXmpp
//
//  Created by zidon on 15/5/11.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftTableViewCell : UITableViewCell

@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) UILabel *receivedMessage;

@end
