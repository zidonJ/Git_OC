//
//  TestArrayKVO.m
//  TestKVC
//
//  Created by Zidon on 16/8/21.
//  Copyright © 2016年 姜泽东. All rights reserved.
//

#import "TestArrayKVO.h"

@implementation TestArrayKVO

{
    NSString *_title;
}

-(instancetype)init
{
    self=[super init];
    if (self) {
        _title=@"jojo";
    }
    return self;
}

@end
