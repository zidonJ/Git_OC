//
//  ViewController.m
//  WCDB_Test
//
//  Created by 姜泽东 on 2017/8/31.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "ViewController.h"
#import <WCDB/WCDB.h>
#import "Student.h"
#import "ElectiveClass.h"
#import <objc/runtime.h>
#import "SHDataBaseUtil.h"
#import "FMDB.h"
#import "DBBase.h"
#import "DBOperate.h"
#import <Realm/Realm.h>
#import "MTRealmModel.h"

static FMDatabaseQueue *_queue;

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITextField *number;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *className;

@property (weak, nonatomic) IBOutlet UISegmentedControl *operateWhich;


@property (nonatomic,strong) NSMutableArray *stuDataArray;
@property (nonatomic,strong) NSMutableArray *clsDataArray;

@property (weak, nonatomic) IBOutlet UISwitch *isHaveSelectSwitch;
@property (weak, nonatomic) IBOutlet UITableView *studentTableView;
@property (weak, nonatomic) IBOutlet UITableView *classTableView;

//学生表
@property (nonatomic,strong) WCTDatabase *database;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
        
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *stuPath = [path stringByAppendingPathComponent:@"stu.db"];
    NSLog(@"数据库路径:%@",stuPath);
    
    _database = [[WCTDatabase alloc] initWithPath:stuPath];
    BOOL result = [_database createTableAndIndexesOfName:@"student"
                                               withClass:Student.class];
    if (result) {
        NSLog(@"数据库表创建成功");
    }
    
    result = [_database createTableAndIndexesOfName:NSStringFromClass(ElectiveClass.class)
                                          withClass:ElectiveClass.class];
    
    if (result) {
        NSLog(@"选修课名单表创建成功");
    }
    
    
    NSString *path1=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path1 = [path1 stringByAppendingString:[NSString stringWithFormat:@"/%@",@"shsqlite.db"]];
    _queue = [[FMDatabaseQueue alloc] initWithPath:path1];
    NSLog(@"%@",path1);
    
    NSString *sql = @"create table if not exists Test(name,content)";
    __block BOOL result1;
    [_queue inDatabase:^(FMDatabase *db) {
        result1=[db executeUpdate:sql];
    }];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource --

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_studentTableView]) {
        return _stuDataArray.count;
    }else {
        return _clsDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_studentTableView]) {
        static NSString *stuCellId = @"stu";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stuCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stuCellId];
        }
        Student *stu = (Student *)_stuDataArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%d,%@,cls:%@",stu.studentID,stu.name,stu.electiveName];
        return cell;
    }else {
        static NSString *clsCellId = @"cls";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:clsCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:clsCellId];
        }
        
        ElectiveClass *els = (ElectiveClass *)_clsDataArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"name:%@,cls:%@",els.stuName,els.className];
        return cell;
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_classTableView]) {
        
        [_stuDataArray removeObjectAtIndex:indexPath.row];
        Student *stu = (Student *)_stuDataArray[indexPath.row];
        [_database deleteObjectsFromTable:NSStringFromClass(Student.class) where:Student.studentID == stu.studentID];
        
    }else {
    
    }
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark -- Action --

#pragma mark --插入&插入性能测试
- (IBAction)addRecord:(UIButton *)sender {
    
    Student *stu = [Student new];
    
    stu.studentID = [_number.text intValue];
    stu.name = _name.text;
    stu.electiveName = _className.text;
    stu.modifiedTime = [NSDate date];
    stu.isHaveSelectCls = _isHaveSelectSwitch.on;
    
    BOOL success = [DBOperate creatTableWithName:@"Student"];
    [DBOperate addOneObject:stu intoTable:@"Student"];
    
    for(Student *stu in [DBOperate getAllDatas:@"Student"]){
        NSLog(@"%@",stu.name);
    }
    
    /*
     设置主键自增时使用
     BOOL result = [_database insertObjects:@[stu] onProperties:Student.AllProperties into:NSStringFromClass(Student.class)];
     */
    [_database insertObjects:@[stu] onProperties:Student.AllProperties into:NSStringFromClass(Student.class)];
//    BOOL result = [_database insertObject:stu into:NSStringFromClass(Student.class)];
//    
//    if (result) {
//        NSLog(@"insert success");
//    }else {
//        NSLog(@"insert failed");
//    }
//
//    
//    ElectiveClass *elective = [ElectiveClass new];
//    
//    elective.stuName = _name.text;
//    elective.className = _className.text;
//    
//    result = [_database insertObject:elective into:NSStringFromClass(ElectiveClass.class)];
//    
//    if (result) {
//        NSLog(@"课程表插入成功");
//    }
    
    
    
    /*同时开启事物模式的情况下插入两条字符串数据10万条数据WCDB与FMDB相差不多,100万条数据时相差大概8*/
    /*
     
     10万条
     2017-09-05 17:43:24.533 WCDB_Test[7948:553372] 32132.346829
     2017-09-05 17:43:25.883 WCDB_Test[7948:553372] 32133.697347
     
     100万条
     2017-09-05 17:44:08.468 WCDB_Test[7988:554742] 32176.283009
     2017-09-05 17:44:23.161 WCDB_Test[7988:554742] 32190.976824
     
     2017-09-11 16:27:08.106 WCDB_Test[15402:554683] 25173.408111
     2017-09-11 16:27:12.652 WCDB_Test[15402:554683] 25177.954541
     */
    
//    NSLog(@"%f",CACurrentMediaTime());
//    WCTTransaction *transaction = [_database getTransaction];
//    BOOL result = [transaction begin];
//    NSMutableArray *muta = [NSMutableArray array];
//    for (int i = 0; i<1000000; i++) {
//        @autoreleasepool {
//            ElectiveClass *elc = [ElectiveClass new];
//            elc.className = [NSString stringWithFormat:@"%d",i];
//            elc.stuName = [NSString stringWithFormat:@"%d",i];
//            [muta addObject:elc];
//        }
//        
//    }
//    [_database insertObjects:muta into:NSStringFromClass(ElectiveClass.class)];
    
//    result = [transaction commit];
//    if (!result) {
//        [transaction rollback];
//    }
//    NSLog(@"%f",CACurrentMediaTime());
    
    
    /*
     10万条
     2017-09-05 17:40:30.621 WCDB_Test[7836:548156] 31958.429873
     2017-09-05 17:40:31.177 WCDB_Test[7836:548156] 31958.985583
     
     100万条
     2017-09-05 17:39:41.886 WCDB_Test[7796:546519] 31909.693188
     2017-09-05 17:39:47.141 WCDB_Test[7796:546519] 31914.948483
     */
//    __block BOOL result;
//    NSLog(@"%f",CACurrentMediaTime());
//    
//    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        for (int i = 0; i<1000000; i++) {
//            
//            NSString *sql = @"INSERT INTO Test(name,content) VALUES (?,?)";
//            result = [db executeUpdate:sql,[NSString stringWithFormat:@"%d",i],[NSString stringWithFormat:@"%d",i]];
//            if (!result) {
//                [db rollback];
//                [db close];
//            }
//        }
//    }];
//
//    
//    NSLog(@"%f",CACurrentMediaTime());
    
    /*
     2017-09-11 16:25:35.244 WCDB_Test[15356:552537] 25080.545120
     2017-09-11 16:25:40.558 WCDB_Test[15356:552537] 25085.859152
     */
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        NSLog(@"%f",CACurrentMediaTime());
        
        NSMutableArray *muta = [NSMutableArray array];
        for (int i = 0; i<1000000; i++) {
            @autoreleasepool {
                MTRealmModel *model = [MTRealmModel new];
                model.className = [NSString stringWithFormat:@"%d",i];
                model.stuName = [NSString stringWithFormat:@"%d",i];
                [muta addObject:model];
            }
        }
        [realm addObjects:muta];
        
        NSLog(@"%f",CACurrentMediaTime());
    }];
    
}

#pragma mark --删除
- (IBAction)delete:(UIButton *)sender {    
    
    /*
     Student *obj = [_database getOneObjectOfClass:Student.class fromTable:NSStringFromClass(Student.class) where:Student.studentID == [_number.text intValue]];
     
     WCTOneColumn *clo = [_database getOneColumnOnResult:Student.studentID fromTable:NSStringFromClass(Student.class)];
     
     NSUInteger index = [clo indexOfObject:@(obj.studentID)];
     
     //表联动删除,NSStringFromClass(ElectiveClass.class) 事先可以保存外键关联的表的字符串即可
     [_database deleteObjectsFromTable:NSStringFromClass(ElectiveClass.class) limit:1 offset:index];
     */
    
    BOOL result = [_database deleteObjectsFromTable:NSStringFromClass(Student.class)
                                              where:Student.studentID == [_number.text intValue] && Student.electiveName ==@"eng"];
    
    
    if (result) {
        NSLog(@"删除成功");
        [self select:nil];
    }
}

#pragma mark --修改
- (IBAction)change:(UIButton *)sender {
    
    Student *stu = [[Student alloc] init];
    stu.name = _name.text;
    
    BOOL result = [_database updateRowsInTable:NSStringFromClass(Student.class)
                                    onProperty:Student.name
                                    withObject:stu
                                         where:Student.studentID == [_number.text intValue]];
    
    if (result) {
        NSLog(@"修改数据成功");
        [self select:nil];
    }
}

#pragma mark --查询
- (IBAction)select:(UIButton *)sender {
    
    NSLog(@"%@",[_database getOneColumnOnResult:Student.studentID fromTable:NSStringFromClass(Student.class)]);
    
    NSArray<Student *> *stu;
    if (_number.text.length == 0 || sender == nil) {
        stu = [_database getObjectsOfClass:Student.class fromTable:NSStringFromClass(Student.class) orderBy:Student.studentID.order(WCTOrderedDescending)];
        
    }else{
        stu = [_database getObjectsOfClass:Student.class fromTable:NSStringFromClass(Student.class) where:Student.studentID == [_number.text intValue]];
    }
    
    int a =  [[[_database getOneObjectOfClass:Student.class fromTable:NSStringFromClass(Student.class)] valueForKey:@"studentID"] intValue];
    
    NSLog(@":::%d",a);
    
    
    /*
     排序后限制查询条数和偏移量
    stu = [_database getObjectsOfClass:Student.class
                             fromTable:NSStringFromClass(Student.class)
                               orderBy:Student.studentID.order(WCTOrderedAscending)
                                 limit:1
                                offset:1];
     
     //获取一行
     WCTOneRow *row = [_database getOneRowOnResults:{Student.studentID} fromTable:NSStringFromClass(Student.class)];
     
     
     NSLog(@"WCTOneRow:%@",row[0]);
     */
        
    _stuDataArray = [stu mutableCopy];
    [_studentTableView reloadData];
    
    NSArray<ElectiveClass *> *cls;
    
    if (_className.text.length == 0) {
        cls = [_database getObjectsOfClass:ElectiveClass.class fromTable:NSStringFromClass(ElectiveClass.class) orderBy:ElectiveClass.stuName.order()];
    }else {
        cls = [_database getObjectsOfClass:ElectiveClass.class fromTable:NSStringFromClass(ElectiveClass.class) where:ElectiveClass.className == _className.text];
    }
    
    _clsDataArray = [cls mutableCopy];
    [_classTableView reloadData];
}

@end
