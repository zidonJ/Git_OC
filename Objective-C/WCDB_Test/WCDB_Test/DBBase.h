//
//  DBOperate.h
//  WCDB_Test
//
//  Created by 姜泽东 on 2017/9/5.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>

/*
 id obj = ((DBBase *(*) (id,SEL))objc_msgSend)(self,NSSelectorFromString(@"shareInstance"));
 ((WCTDatabase *(*)(id,SEL))objc_msgSend)(obj,NSSelectorFromString(@"database"));
 */

@class DBBase;

#define MTDataBase [[DBBase shareInstance] database]

@interface DBBase : NSObject

@property (nonatomic,strong,readonly) WCTDatabase *database;

+ (instancetype)shareInstance;

@end
