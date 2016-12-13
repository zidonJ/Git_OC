//
//  ViewController.m
//  MyFirstCoreData
//
//  Created by zidon on 15/5/11.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataTableViewCell.h"
#import <CoreData/CoreData.h>
#import "Entity.h"
#import "Person.h"
#import "TableViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UISearchBarDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

//声明通过CoreData读取数据要用到的变量
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//用来存储查询并适合TableView来显示的数据
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


@property (nonatomic,strong) UISearchBar *seachBar;

@property (nonatomic,strong) UISearchDisplayController *searchDisplayController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
#pragma mark-------core data------------
    
    
    //通过application对象的代理对象获取上下文
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    self.managedObjectContext = [delegate managedObjectContext];
    
    /*********
     通过CoreData获取sqlite中的数据
     *********/
    
    //通过实体名获取请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Person class])];
    
    //定义分组和排序规则
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstN" ascending:YES];
    
    //把排序和分组规则添加到请求中
    [request setSortDescriptors:@[sortDescriptor]];
    
    //把请求的结果转换成适合tableView显示的数据
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"firstN" cacheName:nil];
    
    //执行fetchedResultsController
    NSError *error;
    if ([self.fetchedResultsController performFetch:&error]) {
        //NSLog(@"%@", [error localizedDescription]);
    }
    self.fetchedResultsController.delegate = self;
    _searchDisplayController=[[UISearchDisplayController alloc] initWithSearchBar:self.seachBar contentsController:self];
    _searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    _searchDisplayController.searchResultsDelegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.coreDataTableView.tableHeaderView=self.seachBar;
}

-(UISearchBar *)seachBar
{
    if (!_seachBar) {
        _seachBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        _seachBar.delegate=self;
    }
    return _seachBar;
}
#pragma mark ---search bar delegate---
//当search中的文本变化时就执行下面的方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //新建查询语句
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Person class])];
    
    //排序规则
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstN" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    //添加谓词
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@",searchText];
    [request setPredicate:predicate];
    
    //把查询结果存入fetchedResultsController中
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"firstN" cacheName:nil];
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

//给我们的通讯录加上索引，下面的方法返回的时一个数组
-(NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    //通过fetchedResultsController来获取section数组
    NSArray *sectionArray = [self.fetchedResultsController sections];
    
    //新建可变数组来返回索引数组，大小为sectionArray中元素的多少
    NSMutableArray *index = [NSMutableArray arrayWithCapacity:sectionArray.count];
    
    //通过循环获取每个section的header,存入addObject中
    for (int i = 0; i < sectionArray.count; i ++)
    {
        id <NSFetchedResultsSectionInfo> info = sectionArray[i];
        [index addObject:[info name]];
    }
    
    //返回索引数组
    return index;
}

//通过获取section中的信息来获取header和每个secion中有多少数据
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *sections = [self.fetchedResultsController  sections];
    //获取对应section的sectionInfo
    id<NSFetchedResultsSectionInfo> sectionInfo = sections[section];
    //返回header
    return [sectionInfo name];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //我们的数据中有多少个section, fetchedResultsController中的sections方法可以以数组的形式返回所有的section
    //sections数组中存的是每个section的数据信息
    NSArray *sections = [self.fetchedResultsController sections];
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = sections[section];
    //返回每个section中的元素个数
    return [sectionInfo numberOfObjects];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark --测试tableview的各种方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark ----测试结束----
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        //通过coreData删除对象
        //通过indexPath获取我们要删除的实体
        
        Person * person = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        //通过上下文移除实体
        [self.managedObjectContext  deleteObject:person];
        //保存
        NSError *error;
        if ([self.managedObjectContext save:&error]) {
            //NSLog(@"%@", [error localizedDescription]);
        }
//        NSIndexSet *set=[[NSIndexSet alloc] initWithIndex:indexPath.row];
//        [self.coreDataTableView reloadSections:set withRowAnimation:UITableViewRowAnimationMiddle];
        
//        NSIndexPath *set=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
//        [self.coreDataTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:set,nil] withRowAnimation:UITableViewRowAnimationRight];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"core";
    CoreDataTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"CoreDataTableViewCell" owner:nil options:nil] lastObject];
    }
    Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.name.text = person.name;
    cell.phone.text = person.tel;
    cell.headImage.image = [UIImage imageWithData:person.imageData];
    return cell;
}

#pragma mark --core data delegate--
//当CoreData的数据正在发生改变是，FRC产生的回调
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.coreDataTableView beginUpdates];
}

//分区改变状况
- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.coreDataTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.coreDataTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            break;
            
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

//数据改变状况
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.coreDataTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert://增
            //让tableView在newIndexPath位置插入一个cell
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete://删
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate://改
            //让tableView刷新indexPath位置上的cell
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove://查
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

//当CoreData的数据完成改变是,FRC产生的回调
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.coreDataTableView endUpdates];
}

- (IBAction)jump:(id)sender {
    TableViewController *tb=[[TableViewController alloc] init];
    [self.navigationController pushViewController:tb animated:YES];
}
@end
