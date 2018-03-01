//
//  ViewController.m
//  GCDLessUse
//
//  Created by 姜泽东 on 2017/11/9.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    dispatch_semaphore_t _semaphore;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self gcd_source];
    [self gcd_semaphore];
    
    
    
}

- (void)gcd_source
{
    
//    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_global_queue(0, 0));
//
//    dispatch_source_set_event_handler(source, ^{
//
//        dispatch_sync(dispatch_get_main_queue(), ^{
//
//            //更新UI
//        });
//    });
//
//    dispatch_resume(source);
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        //网络请求
//        dispatch_source_merge_data(source, 1); //通知队列
//    });
    
    //创建source,以DISPATCH_SOURCE_TYPE_DATA_ADD的方式进行累加，而DISPATCH_SOURCE_TYPE_DATA_OR是对结果进行二进制或运算
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
    
    //事件触发后执行的句柄
    dispatch_source_set_event_handler(source,^{
        
        NSLog(@"监听函数：%lu",dispatch_source_get_data(source));
        
    });
    
    //开启source
    dispatch_resume(source);
    dispatch_queue_t myqueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(myqueue, ^ {
        
        for(int i = 1; i <= 4; i ++){
            
            NSLog(@"~~~~~~~~~~~~~~%d", i);
            
            //触发事件,向source发送事件,这里i不能为0,否则触发不了事件
            dispatch_source_merge_data(source,1);
            
            /*
             如果interval的时间越长,则每次触发都会响应,但是如果interval的时间很短,则会将触发后的结果相加后统一触发.
             */
            //[NSThread sleepForTimeInterval:0.0001];
        }
    });
    
//    //倒计时时间
//    __block int timeout = 30;
//
//    //创建队列
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//    //创建timer
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//
//    //设置1s触发一次,0s的误差
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//
//    //触发的事件
//    dispatch_source_set_event_handler(_timer, ^{
//
//        if(timeout<=0){ //倒计时结束,关闭
//
//            //取消dispatch源
//            dispatch_source_cancel(_timer);
//
//        }else{
//
//            timeout--;
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                //更新主界面的操作
//
//                NSLog(@"~~~~~~~~~~~~~~~~%d", timeout);
//
//            });
//        }
//    });
//
//    //开始执行dispatch源
//    dispatch_resume(_timer);
}

- (void)gcd_semaphore
{
    //创建队列组
    dispatch_group_t group = dispatch_group_create();
    //创建信号量,并且设置值为2
    _semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 2; i++){
        
        /*
         由于是异步执行的,所以每次循环Block里面的’dispatch_semaphore_signal‘根本还没有执行就会执行‘dispatch_semaphore_wait’,
         ’dispatch_semaphore_wait‘每次执行semaphore-1.当循环‘n’此后,semaphore的信号量值等于0,则会阻塞线程,
         ’dispatch_semaphore_signal‘执行semaphore会+1 会重新唤醒
         */
        
        NSLog(@"########################");
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"!!!!!!!!!!!!!!!!!!!!");
        dispatch_group_async(group, queue, ^{
            NSLog(@"%i,%d",i,__LINE__);
            sleep(2);//这里睡眠了2秒 然后重新唤醒信号量 信号量不为0会继续执行任务
            //每次发送信号则semaphore会+1 会重新唤醒信号量
            dispatch_semaphore_signal(_semaphore);
        });
    }
    
}

@end
