//
//  ElectiveClass.m
//  WCDB_Test
//
//  Created by 姜泽东 on 2017/9/1.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "ElectiveClass.h"

@implementation ElectiveClass

WCDB_IMPLEMENTATION(ElectiveClass)
/** WCDB_SYNTHESIZE  定义需要绑定到数据库表的字段 */
WCDB_SYNTHESIZE(ElectiveClass, stuName)
WCDB_SYNTHESIZE(ElectiveClass, className)

//每个学生只能选修一门课程
WCDB_PRIMARY(ElectiveClass, stuName)

@end
