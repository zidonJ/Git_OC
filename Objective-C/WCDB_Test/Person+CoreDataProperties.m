//
//  Person+CoreDataProperties.m
//  WCDB_Test
//
//  Created by 姜泽东 on 2017/9/15.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Person"];
}

@dynamic name;
@dynamic sex;
@dynamic work;
@dynamic age;
@dynamic height;
@dynamic telephone;

@end
