//
//  ViewController.m
//  MyXmpp
//
//  Created by zidon on 15/4/30.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import "ViewController.h"
#import "XMPPFramework.h"
#import "AppDelegate.h"
#import "FriendListViewController.h"
#import "NSDictionary+getKey.h"
#import "NSString+Helper.h"


static NSString * jid=@"";
static NSString * ps=@"";

@interface ViewController ()<UITextFieldDelegate>

#pragma mark --控件--
@property (weak, nonatomic) IBOutlet UITextField *jid;
@property (weak, nonatomic) IBOutlet UITextField *jidPort;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *connect;
@property (weak, nonatomic) IBOutlet UITextField *friendJid;

#pragma mark --xmpp--
@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchivingModule;

@end

@implementation ViewController

-(id)sharedInstance
{
    static ViewController *vc;
    static dispatch_once_t tt;
    dispatch_once(&tt, ^{
        vc=self;
    });
    return vc;
}

-(void)singleInitialize
{
    _xmppStream = xmppDelegate.xmppStream;
    _xmppReconnect=xmppDelegate.xmppReconnect;
    _xmppRosterStorage=xmppDelegate.xmppRosterStorage;
    _xmppRoster=xmppDelegate.xmppRoster;
    _xmppMessageArchivingCoreDataStorage=xmppDelegate.xmppMessageArchivingCoreDataStorage;
    _xmppMessageArchivingModule=xmppDelegate.xmppMessageArchivingModule;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self singleInitialize];
}

- (IBAction)connect:(id)sender {
    _xmppStream.hostPort=_jidPort.text.integerValue;
    [self connectXmpp];
}

// 169.254.83.161 10.130.62.17
static NSString *const localRex=@"192.168.16.93";
-(void)connectXmpp
{
    xmppDelegate.password=_password.text;
    XMPPJID *myjid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",_jid.text,localRex]];
    
//    _xmppStream.hostName = @"zidon.local";
//    XMPPJID *myjid = [XMPPJID jidWithUser:_jid.text domain:@"zidon.local" resource:nil];
    
    NSError *error ;
#pragma mark  ----绑定jid和其对应的resource----
    [_xmppStream setMyJID:myjid];
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        NSLog(@"my connected error :%@",error.description);
    }
}

- (IBAction)regist:(id)sender {
    
}
//登陆
- (IBAction)login:(id)sender {
    if ([_xmppStream isConnected]) {
        //判断密码
        NSError *error;
        if (ps) {
            if ([_xmppStream authenticateWithPassword:ps error:&error]) {
                NSLog(@"error authenticate:%@",error.description);
            }
        }
    }
}
//注销
- (IBAction)logout:(id)sender {
    
}

- (IBAction)fiendList:(id)sender {
    FriendListViewController *friend=[self.storyboard instantiateViewControllerWithIdentifier:@"friend"];
    [self.navigationController pushViewController:friend animated:YES];
}

//添加好友
- (IBAction)addFriend:(UIButton *)sender {
    
    // 1. 用户没有输入
    NSString *friendText = [_friendJid.text trimString];
    if (friendText.length == 0) {
        return;
    }
    
    // 2. 用户只输入了用户名 zhangsan => 拼接域名 zhangsan@zidon.local
    // 判断是否包含@字符
    NSRange range = [friendText rangeOfString:@"@"];
    if (NSNotFound == range.location) {
        // 拼接域名,使用当前账号的域名
        NSString *domain = [xmppDelegate.xmppStream.myJID domain];
        friendText = [NSString stringWithFormat:@"%@@%@", friendText, domain];
    }
    
    // 3. 不能添加自己
    if ([xmppDelegate.xmppStream.myJID.bare isEqualToString:friendText]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能添加自己" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
    }
    
    // 4. 如果已经是好友，则无需添加
    // 如果已经添加成好友，好友的信息会记录在本地数据库中
    // 在本地数据库中直接查找该好友是否存在即可
    XMPPJID *jid = [XMPPJID jidWithString:friendText];
    
    if ([xmppDelegate.xmppRosterStorage userExistsWithJID:jid xmppStream:xmppDelegate.xmppStream]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该好友已经存在，无需添加" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
    }
    
    // 5. 添加好友操作
    NSLog(@"%@", friendText);
    // 在XMPP中添加好友的方法，叫做：“订阅”，类似于微博中的关注
    // 发送订阅请求给指定的用户
    [xmppDelegate.xmppRoster subscribePresenceToUser:jid];
    
    // 6. 显示一个AlertView提示用户
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订阅请求已经发送" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_jid resignFirstResponder];
    [_jidPort resignFirstResponder];
    [_userName resignFirstResponder];
    [_password resignFirstResponder];
    return YES;
}

@end
