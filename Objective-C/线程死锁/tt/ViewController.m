//
//  ViewController.m
//  tt
//
//  Created by 姜泽东 on 2017/8/30.
//  Copyright © 2017年 姜泽东. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <pthread/pthread.h>
#import "TestCollectionViewController.h"

static char *key;

static pthread_mutex_t _mutex;

@interface ViewController ()

@property (nonatomic, strong) NSString *target;

@property (nonatomic, copy) NSString *name;

@end

@implementation ViewController

- (void)test{
    pthread_mutex_lock(&_mutex);
    NSLog(@"%s", __func__);
    static int num = 0;
    if (num < 10) {
        num ++;
        [self test];
    }
    pthread_mutex_unlock(&_mutex);
}

- (void)__initMutex:(pthread_mutex_t *)mutex
{
    // 递归锁：允许同一个线程对一把锁进行重复加锁
    // 初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
    // 初始化锁
    pthread_mutex_init(mutex, &attr);
    // 销毁属性
    pthread_mutexattr_destroy(&attr);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self __initMutex:&_mutex];
//    NSLog(@"1");
//    // 主线程队列 内 异步执行 不会创建新的线程 只有主线成
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"2");
//    });
//    NSLog(@"3");
//
//    // 自定义串行队列 内 异步执行 会创建新的线程 只创建1个
//    dispatch_queue_t qt = dispatch_queue_create("aaa", DISPATCH_QUEUE_SERIAL);
//    dispatch_sync(qt, ^{
//        NSLog(@"bbbb");
//        dispatch_async(qt, ^{
//            NSLog(@"ccc");
//        });
//    });
//
//    // 0101
//    int d = 5;
//    // 1001
//    int f = 9;
//    d = d ^ f; //0011
//    f = d ^ f; //0101
//    d = d ^ f; //1001
    
//    dispatch_queue_t tt = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
//    //tt = dispatch_get_main_queue();  //主线程同步 只有死锁
//
//
//    dispatch_async(tt, ^{
//        NSLog(@"并行:hello");
//    });
//
//    dispatch_sync(tt, ^{
//        NSLog(@"串行:hello");
//    });
    

    
//    _name = @"Andrew";
//
//    objc_setAssociatedObject(self, &key, _name, OBJC_ASSOCIATION_COPY);
//    objc_setAssociatedObject(self, &key, _name, OBJC_ASSOCIATION_COPY);
//
//    self.name = nil;
//    //释放后仍然可以获取到值
//    objc_setAssociatedObject(self, &key, nil, OBJC_ASSOCIATION_COPY);
//    NSLog(@"%@----%@",self.name, objc_getAssociatedObject(self, &key));
    
    
    //    NSLock *lock = NSLock.new;
    //异步执行 数量太大,可能已经释放了 就不能在赋值了
//    dispatch_queue_t queue1 = dispatch_queue_create("parallel", DISPATCH_QUEUE_CONCURRENT);
//    for (int i = 0; i < 10000 ; i++) {
//
//        dispatch_async(queue1, ^{
//            //            [lock lock];
//            self.target = [NSString stringWithFormat:@"ksddkjalkjd%d",i];
//            //            [lock unlock];
//            NSLog(@"%@----%p",self.target,self.target);
//        });
//    }
    
//    __block int i = 0;
//    while (i<5) {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            i++;
//            NSLog(@"%@-------%d",NSThread.currentThread,i);
//        });
//    }
//    NSLog(@"%@-------end:%d",NSThread.currentThread,i);
    
//    dispatch_queue_t qt = dispatch_queue_create("123456", DISPATCH_QUEUE_SERIAL);
//    
//    for (int i = 0; i<15; i++) {
//        dispatch_sync(qt, ^{
//            NSLog(@"同步：%@",NSThread.currentThread);
//        });
//        
//        
//        dispatch_sync(qt, ^{
//            NSLog(@"同步并行：%@",NSThread.currentThread);
//        });
//        
//        
//        dispatch_sync(qt, ^{
//            NSLog(@"同步串行：%@",NSThread.currentThread);
//        });
//    }
//    
//    dispatch_async(qt, ^{
//        NSLog(@"异步：%@",NSThread.currentThread);
//    });
    
    
}


@end
