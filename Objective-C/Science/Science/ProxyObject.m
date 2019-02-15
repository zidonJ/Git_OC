//
//  ProxyObject.m
//  Science
//
//  Created by zidonj on 2018/11/30.
//  Copyright © 2018 langlib. All rights reserved.
//

#import "ProxyObject.h"

@interface ProxyObject ()

@property (nonatomic,strong) id target ;

@end

@implementation ProxyObject

- (id)initWithObject:(id)object {
    self.target = object;
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [self.target methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}

@end
