//
//  Book.h
//  TestKVC
//
//  Created by Zidon on 15/1/27.
//  Copyright (c) 2015年 姜泽东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Author.h"

@interface Book : NSObject
{
    NSString *name;
    Author *author;
    float price;
    NSArray *relativeBooks; 
}

@property (nonatomic,copy) NSString *test;

@end


