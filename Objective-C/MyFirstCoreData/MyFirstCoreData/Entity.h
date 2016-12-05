//
//  Entity.h
//  MyFirstCoreData
//
//  Created by zidon on 15/5/11.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * firstN;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * number;

@end
