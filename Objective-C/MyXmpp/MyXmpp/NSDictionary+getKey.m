//
//  NSDictionary+getKey.m
//  MyXmpp
//
//  Created by zidon on 15/5/11.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import "NSDictionary+getKey.h"

@implementation NSDictionary (getKey)

@dynamic key;

-(NSString *)key
{
    return [[self allKeys] objectAtIndex:0];
}

@end
