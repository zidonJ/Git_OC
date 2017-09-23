//
//  MTRealmModel.h
//  WCDB_Test
//
//  Created by 姜泽东 on 2017/9/11.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#pragma mark Constants


#pragma mark - Enumerations


#pragma mark - Class Interface

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface MTRealmModel : RLMObject


#pragma mark - Properties

@property (nonatomic,copy) NSString *className;
@property (nonatomic,copy) NSString *stuName;

#pragma mark - Constructors


#pragma mark - Static Methods


#pragma mark - Instance Methods


@end
