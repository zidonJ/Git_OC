//
//  Person+CoreDataProperties.h
//  WCDB_Test
//
//  Created by 姜泽东 on 2017/9/15.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *sex;
@property (nullable, nonatomic, copy) NSString *work;
@property (nonatomic) int64_t age;
@property (nonatomic) float height;
@property (nullable, nonatomic, copy) NSString *telephone;

@end

NS_ASSUME_NONNULL_END
