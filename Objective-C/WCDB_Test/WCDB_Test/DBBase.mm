//
//  DBOperate.m
//  WCDB_Test
//
//  Created by 姜泽东 on 2017/9/5.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "DBBase.h"

@interface DBBase ()

@property (nonatomic,strong) WCTDatabase *database;

@end

@implementation DBBase

static DBBase *_instance;

#pragma mark -- public
+ (instancetype)shareInstance
{    
    return [[self alloc] init];
}

#pragma mark -- getter --
- (WCTDatabase *)database
{
    if (!_database) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *stuPath = [path stringByAppendingPathComponent:@"MT.db"];
        NSLog(@"数据库路径->:%@",stuPath);
        
        _database = [[WCTDatabase alloc] initWithPath:stuPath];
    }
    return _database;
}

#pragma mark -- super --
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}


@end
