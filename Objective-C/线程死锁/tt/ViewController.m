//
//  ViewController.m
//  tt
//
//  Created by 姜泽东 on 2017/8/30.
//  Copyright © 2017年 姜泽东. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "TestCollectionViewController.h"

static char *key;

@interface ViewController ()

@property (nonatomic, strong) NSString *target;

@property (nonatomic, copy) NSString *name;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"1");
    // 主线程队列 内 异步执行 不会创建新的线程 只有主线成
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
    
    // 自定义串行队列 内 异步执行 会创建新的线程 只创建1个
    dispatch_queue_t qt = dispatch_queue_create("aaa", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(qt, ^{
        NSLog(@"bbbb");
        dispatch_async(qt, ^{
            NSLog(@"ccc");
        });
    });
    
    // 0101
    int d = 5;
    // 1001
    int f = 9;
    d = d ^ f; //0011
    f = d ^ f; //0101
    d = d ^ f; //1001
    
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
    
    //异步执行 数量太大,可能已经释放了 就不能在赋值了
//    dispatch_queue_t queue1 = dispatch_queue_create("parallel", DISPATCH_QUEUE_CONCURRENT);
//    for (int i = 0; i < 10000 ; i++) {
//        dispatch_async(queue1, ^{
//            self.target = [NSString stringWithFormat:@"ksddkjalkjd%d",i];
//            NSLog(@"%@----%p",self.target,self.target);
//        });
//    }
    
//    _name = @"Andrew";
//
//    objc_setAssociatedObject(self, &key, _name, OBJC_ASSOCIATION_COPY);
//    objc_setAssociatedObject(self, &key, _name, OBJC_ASSOCIATION_COPY);
//
//    self.name = nil;
//    //释放后仍然可以获取到值
//    objc_setAssociatedObject(self, &key, nil, OBJC_ASSOCIATION_COPY);
//    NSLog(@"%@----%@",self.name, objc_getAssociatedObject(self, &key));

}


@end
