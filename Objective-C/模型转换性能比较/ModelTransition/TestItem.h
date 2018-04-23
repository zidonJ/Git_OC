//
//  TestItem.h
//  ModelTransition
//
//  Created by 姜泽东 on 2017/10/12.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ad : NSObject

@property (copy, nonatomic) NSString *image;

@property (strong, nonatomic) NSURL *url;

@end

typedef enum {
    SexMale,
    SexFemale
} Sex;

@interface User : NSObject

/** 名称 */
@property (copy, nonatomic) NSString *name;
/** 头像 */
@property (copy, nonatomic) NSString *icon;
/** 年龄 */
@property (assign, nonatomic) unsigned int age;
/** 身高 */
@property (strong, nonatomic) NSNumber *height;
/** 财富 */
@property (strong, nonatomic) NSDecimalNumber *money;
/** 性别 */
@property (assign, nonatomic) Sex sex;
/** 同性恋 */
@property (assign, nonatomic, getter=isGay) BOOL gay;

@end

@interface Status : NSObject

@property (copy, nonatomic) NSString *text;
/** 微博作者 */
@property (strong, nonatomic) User *user;

@end

@interface TestItem : NSObject

@property (nonatomic,strong) NSMutableArray<Status *> *statuses;
@property (nonatomic,strong) NSMutableArray<Ad *> *ads;



@end


