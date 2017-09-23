//
//  Student.m
//  WCDB_Test
//
//  Created by 姜泽东 on 2017/9/1.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "Student.h"
#import <objc/runtime.h>
#import "ElectiveClass.h"


@implementation Student
/**
 
 WCDB_PRIMARY用于定义主键
 WCDB_INDEX用于定义索引
 WCDB_UNIQUE用于定义唯一约束
 WCDB_NOT_NULL用于定义非空约束
 WCDB_IMPLEMENTATION  定义绑定到数据库的类
 WCDB_SYNTHESIZE  定义需要绑定到数据库表的字段
 WCDB_INDEX 定义了数据库的索引属性。支持定义索引的排序方式。
 WCDB_INDEX(className, indexSubfixName, propertyName)是最简单的用法，它直接定义某个字段为索引。同时，WCDB会将tableName+indexSubfixName作为该索引的名称。
 WCDB_INDEX_ASC(className, indexSubfixName, propertyName)定义索引为升序。
 WCDB_INDEX_DESC(className, indexSubfixName, propertyName)定义索引为降序。
 WCDB_UNIQUE_INDEX(className, indexSubfixName, propertyName)定义唯一索引。
 WCDB_UNIQUE_INDEX_ASC(className, indexSubfixName, propertyName)定义唯一索引为升序。
 WCDB_UNIQUE_INDEX_DESC(className, indexSubfixName, propertyName)定义唯一索引为降序。
 */
WCDB_IMPLEMENTATION(Student)
WCDB_SYNTHESIZE(Student, studentID)
WCDB_SYNTHESIZE(Student, name)
WCDB_SYNTHESIZE(Student, electiveName)
WCDB_SYNTHESIZE(Student, modifiedTime)
WCDB_SYNTHESIZE(Student, isHaveSelectCls)

WCDB_PRIMARY(Student, studentID)


WCDB_INDEX(Student, "_index", studentID)


@end
