//
//  ZDChatViewController.m
//  MyXmpp
//
//  Created by zidon on 15/5/11.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import "ZDChatViewController.h"
#import "NSDictionary+getKey.h"
#import "LeftTableViewCell.h"
#import "RightTableViewCell.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface ZDChatViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation ZDChatViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(void)keyboardShow
{
    NSLog(@"啦啦啦啦");
}
/*
 keyboardChange:{
 UIKeyboardAnimationCurveUserInfoKey = 0;
 UIKeyboardAnimationDurationUserInfoKey = "0.25";
 UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {320, 216}}";
 UIKeyboardCenterBeginUserInfoKey = "NSPoint: {160, 372}";
 UIKeyboardCenterEndUserInfoKey = "NSPoint: {160, 588}";
 UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 264}, {320, 216}}";
 UIKeyboardFrameChangedByUserInteraction = 0;
 UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 480}, {320, 216}}";
 }
 */
static CGRect rect;
-(void)keyboardDidHide:(NSNotification *)noti
{
    rect=[[noti.userInfo objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    self.topLayout.constant=1;
}

-(void)keyboardWillChangeFrame:(NSNotification *)noti
{
    rect=[[noti.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    self.topLayout.constant=-rect.size.height;
}

-(void)keyboardDidChangeFrame:(NSNotification *)noti
{
//    rect=[[noti.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
//    self.topLayout.constant=-rect.size.height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    xmppDelegate.receiveMessage=^(NSDictionary *dict){
        [self.dataArray addObject:dict];
        [self.chatTableView reloadData];
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _sendMessage.returnKeyType=UIReturnKeySend;
}

-(void)setMessageDict:(NSDictionary *)messageDict
{
    _messageDict=messageDict;
    [self.dataArray addObject:_messageDict];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=self.dataArray[indexPath.row];
    NSString *content=dict[dict.key];
    CGSize size=[content boundingRectWithSize:CGSizeMake(Screen_Width-100, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    if (size.height>=44) {
        return size.height;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=_dataArray[indexPath.row];
    if ([dict.key isEqualToString:@"left"]) {
        static NSString *leftId=@"left";
        LeftTableViewCell *left=[tableView dequeueReusableCellWithIdentifier:leftId];
        if (!left) {
            left=[[LeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftId];
        }
        left.content=dict[dict.key];
        return left;
    }else{
        static NSString *rightId=@"right";
        RightTableViewCell *right=[tableView dequeueReusableCellWithIdentifier:rightId];
        if (!right) {
            right=[[RightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightId];
        }
        right.content=dict[dict.key];
        return right;
    }
}

- (IBAction)sendMessage:(UIButton *)sender {
    NSString *text=[_sendMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length > 0) {
        // 2. 实例化一个XMPPMessage（XML一个节点），发送出去即可
        XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:_chatJid];
        [message addBody:text];
        [xmppDelegate.xmppStream sendElement:message];
        [self.dataArray addObject:@{@"right":text}];
    }
    [_chatTableView reloadData];
    _sendMessage.text=@"";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *text=[_sendMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length > 0) {
        // 2. 实例化一个XMPPMessage（XML一个节点），发送出去即可
        XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:_chatJid];
        [message addBody:text];
        [xmppDelegate.xmppStream sendElement:message];
        [self.dataArray addObject:@{@"right":text}];
    }
    [_chatTableView reloadData];
    _sendMessage.text=@"";
    [_sendMessage resignFirstResponder];
    return YES;
}

@end
