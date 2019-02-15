//
//  Lock.m
//  Science
//
//  Created by zidonj on 2018/11/7.
//  Copyright © 2018 langlib. All rights reserved.
//

#import "Lock.h"
#import <pthread.h> // pthread_mutex_t
#import <libkern/OSAtomic.h> //OSSpinLock
#import <os/lock.h> //os_unfair_lock
#import <QuartzCore/QuartzCore.h>

/*
 同程下性能比较
 1.OSSpinLock(os_unfair_lock)
 2.dispatch_semaphore_t
 3.pthread_mutex_t
 */

@interface Lock () {
    
    /// 递归锁,这个锁可以被同一线程多次请求,而不会引起死锁,主要用在循环或递归操作中.
    NSRecursiveLock *_recursiveLock;
    NSLock *_nslock;
    /// 信号量
    dispatch_semaphore_t _semaphore;
    NSCondition *_condition;
    NSConditionLock *_conditionLock;
    
    /*
     自旋锁
     OSSpinLock 在iOS中废弃;
     如果一个低优先级的线程获得锁并访问共享资源，这时一个高优先级的线程也尝试获得这个锁，它会处于 spin lock 的忙等状态从而占用大量 CPU。此时低优先级线程无法与高优先级
     线程争夺 CPU 时间，从而导致任务迟迟完不成、无法释放 lock。这并不只是理论上的问题，libobjc 已经遇到了很多次这个问题了，于是苹果的工程师停用了 OSSpinLock。
     */
}

@end

@implementation Lock

static pthread_once_t once = PTHREAD_ONCE_INIT;

///互斥锁
static pthread_mutex_t mutex;

/// 替代在iOS10中被废弃的OSSpinLock
static os_unfair_lock _unfair_lock;

void init() {
    pthread_mutex_init(&mutex, NULL);
    _unfair_lock = OS_UNFAIR_LOCK_INIT;
}

- (void)performWork {
    
    ///int pthread_once(pthread_once_t *once_control, void (*init_routine) (void));
    ///保证只初始化一次
    pthread_once(&once, init); // Correct
//    pthread_mutex_lock(&mutex);
    
    _semaphore = dispatch_semaphore_create(1);
    for (int i = 0; i < 1000; i++) {
        //NSLog(@"%d",i);
        
//        os_unfair_lock_lock(&_unfair_lock);//0.018694
//        os_unfair_lock_unlock(&_unfair_lock);
        
//        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);//0.018973
//        dispatch_semaphore_signal(_semaphore);
        
//        pthread_mutex_lock(&mutex);//0.025182
//        pthread_mutex_unlock(&mutex);
        
//        @synchronized(self) {} //0.102369
    }
//    pthread_mutex_unlock(&mutex);
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self performWork];
//        });
        
        [self performWork];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self performWork];
            [self performWork];
            [self performWork];
            [self performWork];
        });
        [self performWork];
        
    }
    return self;
}

@end


