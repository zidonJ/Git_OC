//
//  ChatViewController.m
//  MyXmpp
//
//  Created by zidon on 15/5/8.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import "ChatViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface ChatViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate,NSFetchedResultsControllerDelegate>
{
    // 查询结果控制器
    NSFetchedResultsController *_fetchResultsController;
    
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jojo)];
    [_imageContent addGestureRecognizer:tap];
    // 绑定数据
    [self dataBinding];
}

#pragma mark - 绑定数据
- (void)dataBinding
{
    // 1. 数据库的上下文
    NSManagedObjectContext *context = xmppDelegate.xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext;
    
    // 2. 定义查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    // 3. 定义排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    [request setSortDescriptors:@[sort]];
    
    // 4. 需要过滤查询条件，谓词，过滤当前对话双发的聊天记录，将“lisi”的聊天内容取出来
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@", _chatJid.bare];
    [request setPredicate:predicate];
    
    // 5. 实例化查询结果控制器
    _fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    // 设置代理，接收到数据变化时，刷新表格
    _fetchResultsController.delegate = self;
    
    // 6. 执行查询
    NSError *error = nil;
    if (![_fetchResultsController performFetch:&error]) {
        YYLog(@"%@", error.localizedDescription);
    }
}

-(void)jojo
{
    YYLog(@"jojo")
}

- (IBAction)send:(id)sender {
    // 回车发送消息
    // 1. 检查是否有内容
    NSString *text=[_textContent.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length > 0) {
        // 2. 实例化一个XMPPMessage（XML一个节点），发送出去即可
        XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:_chatJid];
        
        [message addBody:text];
        
        [xmppDelegate.xmppStream sendElement:message];
    }
    _textContent.text=@"";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

@end
