//
//  ChatViewController.h
//  MyXmpp
//
//  Created by zidon on 15/5/8.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPJID.h"

@interface ChatViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *chatContent;
@property (weak, nonatomic) IBOutlet UITextField *textContent;
- (IBAction)send:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageContent;

//聊天的Jid
@property (nonatomic,copy) XMPPJID *chatJid;

@end
