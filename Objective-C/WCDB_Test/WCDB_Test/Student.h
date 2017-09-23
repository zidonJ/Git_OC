//
//  Student.h
//  WCDB_Test
//
//  Created by 姜泽东 on 2017/9/1.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>


@interface Student : NSObject

@property int studentID;
@property(retain) NSString *name;
@property(retain) NSString *electiveName;
@property(retain) NSDate *modifiedTime;
@property(assign) BOOL isHaveSelectCls;

@end

@interface Student (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(studentID)
WCDB_PROPERTY(name)
WCDB_PROPERTY(electiveName)
WCDB_PROPERTY(modifiedTime)
WCDB_PROPERTY(isHaveSelectCls)

@end


