//
//  CacheItem.h
//  QMUIKit_Study
//
//  Created by zidonj on 2019/12/16.
//  Copyright © 2019 zidonj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CacheItem : NSObject

@property (nonatomic, strong) Class cellClass;
@property (nonatomic, copy) NSString *imgUrl1;
@property (nonatomic, copy) NSString *imgUrl2;
@property (nonatomic, copy) NSString *text;

@end

NS_ASSUME_NONNULL_END
