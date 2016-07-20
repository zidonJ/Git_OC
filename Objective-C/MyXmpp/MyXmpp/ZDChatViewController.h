//
//  ZDChatViewController.h
//  MyXmpp
//
//  Created by zidon on 15/5/11.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPJID.h"

@interface ZDChatViewController : UIViewController

//聊天的Jid
@property (nonatomic,strong) XMPPJID *chatJid;
//接收到的消息
@property (nonatomic,strong) NSDictionary *messageDict;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@property (weak, nonatomic) IBOutlet UITextField *sendMessage;
- (IBAction)sendMessage:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
