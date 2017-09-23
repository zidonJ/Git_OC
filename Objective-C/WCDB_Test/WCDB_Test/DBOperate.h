//
//  DBOperate.h
//  WCDB_Test
//
//  Created by 姜泽东 on 2017/9/5.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBBase.h"

@interface DBOperate : NSObject


/**
 创建表

 @param className 表名字
 @return 创建成功
 */
+ (BOOL)creatTableWithName:(NSString *)className;

#pragma mark -- 插入
/**
 插入一条数据

 @param object 插入对象
 @param classString 表名字
 */
+ (BOOL)addOneObject:(NSObject<WCTTableCoding> *)object intoTable:(NSString *)classString;


/**
 插入多条数据

 @param objects 插入数组
 @param classString 表名字
 */
+ (BOOL)addObjects:(NSArray<NSObject<WCTTableCoding> *> *)objects intoTable:(NSString *)classString;

/**
 当设置主键自增的时候需要用这个方法

 @param objects 插入数组
 @param propertyList 属性列表 {Student.studentID},Student.AllProperties
 @param classString 表名字
 */
+ (BOOL)addObjects:(NSArray<NSObject<WCTTableCoding> *> *)objects onProperties:(const WCTPropertyList &)propertyList intoTable:(NSString *)classString;

#pragma mark -- 删除

/**
 删除

 @param condition 组合条件（可以是多个属性的‘||’ ‘&&’的关系）
 @param count 限制数量
 @param classString 表名字
 */
+ (BOOL)deleteContion:(const WCTCondition &)condition limit:(NSInteger)count formTable:(NSString *)classString;


#pragma mark -- 修改

+ (BOOL)updateObject:(NSObject<WCTTableCoding> *)object onProperty:(WCTProperty)property condition:(const WCTCondition &)condition inTable:(NSString *)classString;


#pragma mark -- 查询

+ (NSArray<WCTObject *> *)getAllDatas:(NSString *)tableName;

+ (NSArray<WCTObject*> *)getDatas:(NSString *)tableName condition:(const WCTCondition &)condition;

@end
