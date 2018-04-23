//
//  TModel.m
//  ModelTransition
//
//  Created by 姜泽东 on 2017/9/5.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "TModel.h"

@implementation TModel

/*
 @"shadows" : Shadow.class,
 @"borders" : Border.class, 模型类的集合属性内元素是其他的类的时候
 
 
 @"shadows" : Shadow.class,
 @"borders" : Border.class,
 @"attachments" : @"Attachment"
 */

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"n",
             @"page" : @"p",
             @"desc" : @"ext.desc",
             @"bookID" : @[@"id",@"ID",@"book_id"],
             @"name1": @"name",
             };
}

@end

@implementation CTModel



@end
