//
//  Person.h
//  MyFirstCoreData
//
//  Created by zidon on 15/8/6.
//  Copyright © 2015年 zidon. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * firstN;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSData * imageData;

@end
