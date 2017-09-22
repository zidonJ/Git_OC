//
//  Company+CoreDataProperties.h
//  WCDB_Test
//
//  Created by 姜泽东 on 2017/9/15.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "Company+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Company (CoreDataProperties)

+ (NSFetchRequest<Company *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *companyName;
@property (nullable, nonatomic, copy) NSString *location;
@property (nullable, nonatomic, copy) NSString *personName;

@end

NS_ASSUME_NONNULL_END
