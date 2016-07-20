//
//  FriendListViewController.m
//  MyXmpp
//
//  Created by zidon on 15/5/8.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import "FriendListViewController.h"
#import "AppDelegate.h"
#import "ChatViewController.h"

@interface FriendListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *friendTList;

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 绑定数据，初始化查询结果控制器，设置查询请求条件
    [self dataBinding];
}

- (void)dataBinding
{
    // 1. 获取到花名册的上下文
    NSManagedObjectContext *context = xmppDelegate.xmppRosterStorage.mainThreadManagedObjectContext;
    // 2. 查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    // 3. 排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    
    request.sortDescriptors = @[sort];
    
    // 4. 实例化查询结果控制器
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    // 5. 设置代理
    _fetchedResultsController.delegate = self;
    
    // 6. 控制器执行查询
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        YYLog(@"%@", error.localizedDescription);
    }
}

#pragma mark - 查询结果控制器的代理方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // 数据内容变化时，刷新表格数据
    [_friendTList reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> info = _fetchedResultsController.sections[section];
    
    return [info numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    XMPPUserCoreDataStorageObject *user = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = user.displayName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //ChatViewController *chat=[self.storyboard instantiateViewControllerWithIdentifier:@"chat"];
    ZDChatViewController *chat=[self.storyboard instantiateViewControllerWithIdentifier:@"mc"];
    XMPPUserCoreDataStorageObject *user = [_fetchedResultsController objectAtIndexPath:indexPath];
    chat.chatJid=user.jid;
    [self.navigationController pushViewController:chat animated:YES];
}

@end
