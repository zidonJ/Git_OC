//
//  TModel.h
//  ModelTransition
//
//  Created by 姜泽东 on 2017/9/5.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shadow : NSObject

@end

@interface Border : NSObject

@end

@interface CTModel : NSObject

@property NSString *name;
@property NSDate *birthday;

@end

@interface TModel : NSObject

//@property UInt64 uid;
//@property NSString *name;
//@property NSDate *created;

//--------------
//@property NSString *name;
//@property NSInteger page;
//@property NSString *desc;
//@property NSString *bookID;

//--------------
@property NSString *name;
@property NSUInteger pages;
@property CTModel *author;

@property NSArray *shadows; //Array<Shadow>
@property NSSet *borders; //Set<Border>
@property NSMutableDictionary *attachments; //Dict<NSString,Attachment>

@end
