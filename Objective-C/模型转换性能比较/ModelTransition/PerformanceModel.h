//
//  PerformanceModel.h
//  ModelTransition
//
//  Created by 姜泽东 on 2017/9/5.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bag : NSObject

@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) double price;

@end

@interface PerformanceModel : NSObject

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *nowName;
@property (copy, nonatomic) NSString *oldName;
@property (copy, nonatomic) NSString *nameChangedTime;
@property (strong, nonatomic) Bag *bag;

@end

@interface Bag1 : NSObject

@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) double price;

@end

@interface PerformanceModel1 : NSObject

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *nowName;
@property (copy, nonatomic) NSString *oldName;
@property (copy, nonatomic) NSString *nameChangedTime;
@property (strong, nonatomic) Bag *bag;

@end
