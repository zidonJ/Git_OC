//
//  DBOperate.m
//  WCDB_Test
//
//  Created by 姜泽东 on 2017/9/5.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "DBOperate.h"

@implementation DBOperate

+ (BOOL)creatTableWithName:(NSString *)className
{
    return [MTDataBase createTableAndIndexesOfName:className withClass:NSClassFromString(className)];
}

+ (BOOL)addOneObject:(NSObject<WCTTableCoding> *)object intoTable:(NSString *)classString
{
    return [MTDataBase insertObject:object
                               into:classString];
}

+ (BOOL)addObjects:(NSArray<NSObject<WCTTableCoding> *> *)objects intoTable:(NSString *)classString
{
    return [MTDataBase insertObjects:objects into:classString];
}

+ (BOOL)addObjects:(NSArray<NSObject<WCTTableCoding> *> *)objects onProperties:(const WCTPropertyList &)propertyList intoTable:(NSString *)classString
{
    return [MTDataBase insertObjects:objects
                        onProperties:propertyList
                                into:classString];
}

+ (BOOL)deleteContion:(const WCTCondition &)condition limit:(NSInteger)count formTable:(NSString *)classString
{
    return [MTDataBase deleteObjectsFromTable:classString
                                        where:condition
                                        limit:count];
}

+ (BOOL)updateObject:(NSObject<WCTTableCoding> *)object onProperty:(WCTProperty)property condition:(const WCTCondition &)condition inTable:(NSString *)classString
{
    
    return [MTDataBase updateRowsInTable:classString
                              onProperty:property
                              withObject:object
                                   where:condition];
    
}

+ (NSArray<WCTObject *> *)getAllDatas:(NSString *)tableName
{
    WCTTable *table = [MTDataBase getTableOfName:tableName
                                       withClass:NSClassFromString(tableName)];
    
    return [table getAllObjects];
}

+ (NSArray<WCTObject*> *)getDatas:(NSString *)tableName condition:(const WCTCondition &)condition
{
    WCTTable *table = [MTDataBase getTableOfName:tableName
                                       withClass:NSClassFromString(tableName)];
    
    return [table getObjectsWhere:condition];
}

@end
