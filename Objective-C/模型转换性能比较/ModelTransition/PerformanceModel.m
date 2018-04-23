//
//  PerformanceModel.m
//  ModelTransition
//
//  Created by 姜泽东 on 2017/9/5.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "PerformanceModel.h"

@implementation Bag



@end

@implementation PerformanceModel


@end

@implementation Bag1



@end

@implementation PerformanceModel1

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID" : @"id",
             @"desc" : @"desciption",
             @"oldName" : @"name.oldName",
             @"nowName" : @"name.newName",
             @"nameChangedTime" : @"name.info[1].nameChangedTime",
             @"bag" : @"other.bag"
             };
}

@end
