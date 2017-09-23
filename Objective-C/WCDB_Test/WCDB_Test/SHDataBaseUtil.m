//
//  DHDataBaseUtil.m
//  JZDDataBase
//
//  Created by zidonj on 2017/1/3.
//  Copyright © 2017年 姜泽东. All rights reserved.
//

#import "SHDataBaseUtil.h"
#import "FMDB.h"

static FMDatabaseQueue *_queue;

@implementation SHDataBaseUtil

+(void)initialize
{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path=[path stringByAppendingString:[NSString stringWithFormat:@"/%@",@"shsqlite.db"]];
    _queue=[[FMDatabaseQueue alloc] initWithPath:path];
}

+(BOOL)creatTable:(NSString *)tableName
{
    NSString *sql=[NSString stringWithFormat:CREATE_TABLE_SQL,tableName];
    __block BOOL result;
    [_queue inDatabase:^(FMDatabase *db) {
        result=[db executeUpdate:sql];
    }];
    return result;
}

//存
+(void)saveData:(id)data forKey:(NSString *)key tableName:(NSString *)tableName
{
    BOOL success = [self creatTable:tableName];
    if (!success) {
        NSLog(@"创建表失败");
        return;
    }
    NSData *saveData=[NSKeyedArchiver archivedDataWithRootObject:data];
    NSString *sqlInsert=[NSString stringWithFormat:INSERT_SQL,tableName];
    __block BOOL result;
    [_queue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sqlInsert, key, saveData];
    }];
    if (!result) {
        NSLog(@"ERROR, failed to insert/replace into table: %@", tableName);
    }
}
//修改
+(void)updateData:(id)data key:(NSString *)key tableName:(NSString *)tableName
{
    NSData *saveData=[NSKeyedArchiver archivedDataWithRootObject:data];
    NSString *sqlupdate=[NSString stringWithFormat:Update_Sql,tableName,@"content"];
    __block BOOL result;
    [_queue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sqlupdate,saveData,key];
    }];
}
//取
+(id)getDataForKey:(NSString *)key fromTable:(NSString *)tableName
{
    __block FMResultSet *set=nil;
    __block NSData *result;
    NSString *selectSql=[NSString stringWithFormat:QUERY_ITEM_SQL,tableName];
    [_queue inDatabase:^(FMDatabase *db) {
        [db open];
        set=[db executeQuery:selectSql,key];
        while ([set next]) {
            result=[set dataForColumn:@"content"];
        }
        [set close];
        [db close];
    }];
    [_queue close];
    return [NSKeyedUnarchiver unarchiveObjectWithData:result];
}
//获取所有数据
+(NSArray *)getAllData:(NSString *)tableName
{
    __block FMResultSet *set=nil;
    __block NSMutableArray *result=[@[] mutableCopy];
    NSString *selectSql=[NSString stringWithFormat:QUERY_All_SQL,tableName];
    [_queue inDatabase:^(FMDatabase *db) {
        [db open];
        set=[db executeQuery:selectSql,tableName];
        while ([set next]) {
            NSData *temp=[set dataForColumn:@"content"];
            [result addObject:[NSKeyedUnarchiver unarchiveObjectWithData:temp]];
        }
        [set close];
        [db close];
    }];
    [_queue close];
    return result;
}

@end
