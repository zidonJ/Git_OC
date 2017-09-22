//
//  DHDataBaseUtil.h
//  JZDDataBase
//
//  Created by zidonj on 2017/1/3.
//  Copyright © 2017年 姜泽东. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const CREATE_TABLE_SQL =
@"CREATE TABLE IF NOT EXISTS %@ ( \
id INTEGER primary key autoincrement, \
key TEXT NOT NULL,\
content TEXT NOT NULL, \
PRIMARY KEY(id)) \
";


static NSString *const INSERT_SQL=@"insert or replace into %@ (key, content) values (?, ?)";

static NSString *const Update_Sql=@"update %@ set %@=? where key=?";

static NSString *const QUERY_ITEM_SQL = @"SELECT * from %@ where key = ? Limit 1";
static NSString *const QUERY_All_SQL = @"SELECT * from %@ order by id asc";

@interface SHDataBaseUtil : NSObject

//存
+(void)saveData:(id)data forKey:(NSString *)key tableName:(NSString *)tableName;
//取
+(id)getDataForKey:(NSString *)key fromTable:(NSString *)tableName;
//取所有
+(NSArray *)getAllData:(NSString *)tableName;
//修改
+(void)updateData:(id)data key:(NSString *)key tableName:(NSString *)tableName;

@end
