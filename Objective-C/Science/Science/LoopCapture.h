//
//  LoopCapture.h
//  Science
//
//  Created by zidonj on 2018/11/7.
//  Copyright © 2018 langlib. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoopCapture : NSObject

+ (instancetype)sharedRunLoopWorkDistribution;

- (void)start;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
