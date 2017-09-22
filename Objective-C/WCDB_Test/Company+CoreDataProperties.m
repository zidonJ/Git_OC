//
//  Company+CoreDataProperties.m
//  WCDB_Test
//
//  Created by 姜泽东 on 2017/9/15.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "Company+CoreDataProperties.h"

@implementation Company (CoreDataProperties)

+ (NSFetchRequest<Company *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Company"];
}

@dynamic companyName;
@dynamic location;
@dynamic personName;

@end
