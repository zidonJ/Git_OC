//
//  AppDelegate.m
//  MyXmpp
//
//  Created by zidon on 15/4/30.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<XMPPStreamDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 断言！再此程序断言：_xmppStream必须是nil，如果不是nil，程序强行中断！
    // 要求调用方，必须自觉自律，要求是唯一的，你就应该是唯一的。
    // 断言针对程序的核心代码区，有重要的保护作用！
    // 要求在开发过程中，就能够及时的发现错误，而不是去频繁的修改核心代码！
    NSAssert(_xmppStream == nil, @"XMPPStream被重复实例化！");
    //数据流
    _xmppStream = [[XMPPStream alloc] init];
    _xmppStream.enableBackgroundingOnSocket = YES;
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //连接
    _xmppReconnect = [[XMPPReconnect alloc] init];
    [_xmppReconnect activate:self.xmppStream];
    //好友列表
    //好友列表保存策略
    _xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterStorage];
    [_xmppRoster activate:self.xmppStream];
    // 提示后续可以探索，需要认证添加好友的功能！
    [_xmppRoster setAutoAcceptKnownPresenceSubscriptionRequests:YES];
    // 自动从服务器加载好友信息
    [_xmppRoster setAutoFetchRoster:YES];
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //消息
    //创建消息保存策略(规则,规定)
    _xmppMessageArchivingCoreDataStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
     //用消息保存策略创建消息保存组件
    _xmppMessageArchivingModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage];
    [_xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    [_xmppMessageArchivingModule activate:_xmppStream];
    [_xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    return YES;
}

#pragma mark --功能函数--
- (void)goOnline
{
    YYLog(@"用户上线");
    // 通知服务器用户上线,服务器知道用户上线后,可以根据服务器记录的好友关系,
    // 通知该用户的其他好友,当前用户上线
    XMPPPresence *presence = [XMPPPresence presence];
    YYLog(@"%@", presence);
    // 将展现状态发送给服务器
    [_xmppStream sendElement:presence];
}

- (void)goOffline
{
    YYLog(@"用户下线");
    // 通知服务器用户下线
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    YYLog(@"%@", presence);
    [_xmppStream sendElement:presence];
}

- (void)disconnect
{
    // 通知服务器，我下线了
    [self goOffline];
    // 真正的断开连接
    [_xmppStream disconnect];
}

#pragma mark --xmpp 代理--
- (void)xmppStreamWillConnect:(XMPPStream *)sender
{
    YYLog(@"xmppStreamWillConnect_将要连接");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    YYLog(@"xmppStreamDidConnect_已经连接:连接成功");
    if (self.password.length) {
        NSError *error;
        //这里就是登录了
        if (![self.xmppStream authenticateWithPassword:self.password error:&error]) {
            NSLog(@"error authenticate : %@",error.description);
        }
        //[self.xmppStream registerWithPassword:ps error:&error]; 注册
    }
}
/**
 *  与连接相关的代理
 *
 */
//被告知不能连接
- (void)xmppStreamWasToldToDisconnect:(XMPPStream *)sender
{
    YYLog(@"xmppStreamWasToldToDisconnect");
}
//连接超时
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    YYLog(@"xmppStreamConnectDidTimeout");
}
//连接失败,断开连接
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    YYLog(@"xmppStreamDidDisconnect: %@",error.description);
}

/**
 *  与登录相关的代理
 */
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"xmppStreamDidAuthenticate:身份认证成功,登录成功");
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}
#pragma mark --身份认证失败的回调方法--
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"didNotAuthenticate,身份认证失败:%@",error.description);
}
/**
 *  返回的resource是出现冲突以后需要使用的resource。
 *  注意:同一resource第一次bind的时候会返回conflict冲突的error。但是第二次再使用该resource的时候，可以绑定成功。
 *  当出现resource冲突的时候，仍然使用当前约定的resource,即挤掉其他客户端正在使用的帐号。
 *  此种业务需要实现XMPPStream的回调方法
 */
#pragma mark --检测resource冲突--
- (NSString *)xmppStream:(XMPPStream *)sender alternativeResourceForConflictingResource:(NSString *)conflictingResource
{
    NSLog(@"alternativeResourceForConflictingResource: %@",conflictingResource);
    return @"XMPPIOS";
}
//收到消息,会话消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@":::didReceiveMessage: %@\nmessage.body:%@\nmessage.subject:%@",message.description,message.body,message.subject);
    /*
     <message xmlns="jabber:client" type="chat" id="purplebde1b70c" to="zidon@zidon.local/8213456f" from="andrew@zidon.local/zidon">
     <active xmlns="http://jabber.org/protocol/chatstates"/>
     <body>是喜还是忧,都是我的独家感受</body>
     <html xmlns="http://jabber.org/protocol/xhtml-im">
     <body xmlns="http://www.w3.org/1999/xhtml">
     <p><span style="font-family: Heiti SC; font-size: medium;">是喜还是忧</span>,都是我的独家感受</p>
     </body></html></message>
     message.body:是喜还是忧,都是我的独家感受
     message.subject:(null)
     */
    if (message.body&&message.body.length) {
        self.receiveMessage(@{@"left":message.body});
    }
}
//接收到展现，好友请求等
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    //subscribe 订阅
    if ([presence.type isEqualToString:@"subscribe"]) {
        NSLog(@"接受到好友请求");
        // 订阅我的人是presence.from
        // 接受from的请求即可  同意接受好友请求 rejectPresenceSubscriptionRequestFrom  拒绝接受好友请求
        [_xmppRoster acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
    }
    return ;
}
//接收到请求
-(BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
}
- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
