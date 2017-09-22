//
//  ElectiveClass.h
//  WCDB_Test
//
//  Created by 姜泽东 on 2017/9/1.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>

@interface ElectiveClass : NSObject

@property (nonatomic,copy) NSString *className;
@property (nonatomic,copy) NSString *stuName;

@end


@interface ElectiveClass (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(stuName)
WCDB_PROPERTY(className)

@end
