//
//  ViewController.m
//  ModelTransition
//
//  Created by 姜泽东 on 2017/9/5.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "ViewController.h"
#import "TModel.h"
#import <NSObject+YYModel.h>
#import <MJExtension/MJExtension.h>
#import "PerformanceModel.h"
#import "TestItem.h"
#import <WebKit/WebKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIView+Corner.h"
#import "UIView+ViewCorner.h"
#import "bbb.h"
#import "UIView+RoundedCorners.h"

@interface ViewController ()<WKNavigationDelegate>
{
    
    WKWebView *webView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //colorWithHexString(@"sdf");
    NSString *str1 = @"1234567890";
    str1 = [str1 substringToIndex:2];
    NSLog(@"%@",str1);
    
    
    
    
    NSString *str = @"12345678";
    NSLog(@"%@",[str substringToIndex:2]);
    NSLog(@"%@",[str substringToIndex:str.length]);
    NSLog(@"%@",[str substringToIndex:str.length-1]);
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 200, 100)];
    v.backgroundColor = [UIColor greenColor];
    
    v.layer.shadowOpacity = 0.5;
    v.layer.shadowColor = [UIColor redColor].CGColor;
    v.layer.shadowOffset = CGSizeMake(-2, -2);
    v.layer.shadowPath = [UIBezierPath bezierPathWithRect:v.bounds].CGPath;
    [self.view addSubview:v];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 150, 200, 200);
    [btn setTitle:@"hjk" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
//    btn.layer.cornerRadius = 5;
//    btn.clipsToBounds = YES;
    [btn setRoundedCorners:UIRectCornerAllCorners radius:25 borderColor:[UIColor purpleColor] borderWidth:1];

    [self.view addSubview:btn];
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(10, 360, 200, 200)];
    [self.view addSubview:v1];
    
    UILabel *label = [UILabel new];
    label.frame = v1.bounds;
    label.text = @"ghjkl";
    label.backgroundColor = [UIColor redColor];
    
//    label.layer.cornerRadius = 5;
//    label.layer.masksToBounds = YES;
    
    [label setRoundedCorners:UIRectCornerAllCorners radius:2 borderColor:[UIColor greenColor] borderWidth:1];
    
    [v1 addSubview:label];
    
    
    
    
    
//    UILabel *label1 = [UILabel new];
//    label1.frame = CGRectInset(label.frame, -10, -10);
//    label1.text = @"ghjklmnmmbnmnb";
//    label1.backgroundColor = [UIColor purpleColor];

//    [label1 setRoundedCorners:UIRectCornerAllCorners radius:25];
//
//    [self.view addSubview:label1];


    
    
    NSDictionary *dict = @{
                           @"uid":@(123456),
                           @"name":@"Harry",
                           @"created":@"1965-07-31T00:00:00+0000"
                           };
    
    //数据字段与模型字段不匹配的时候,在模型内部实现修改方法
    dict = @{
             @"n":@"Harry Pottery",
             @"p": @(256),
             @"ext" : @{
                 @"desc" : @"A book written by J.K.Rowing."
             },
             @"ID" : @(100010)
             };
    
    
    //模型内包含其其它模型,当两个模型有一个名字相同类型也相同，外部模型可能不能赋值，需要在模型的.m文件配置一次
    dict = @{
             @"author":@{
                 @"name":@"J.K.Rowling",
                 @"birthday":@"1965-07-31T00:00:00+0000"
             },
             @"name":@"Harry Potter",
             @"pages":@(256)
             };
    
    
    
    //YYModel的简单测试 断点查看赋值情况
    TModel *model = [TModel yy_modelWithJSON:dict];
    
    
    //性能测试
    dict = @{
             @"id" : @"20",
             @"desciption" : @"kids",
             @"name" : @{
                     @"newName" : @"lufy",
                     @"oldName" : @"kitty",
                     @"info" : @[
                             @"test-data",
                             @{
                                 @"nameChangedTime" : @"2013-08"
                                 }
                             ]
                     },
             @"other" : @{
                     @"bag" : @{
                             @"name" : @"a red bag",
                             @"price" : @100.7
                             }
                     }
             };
    

    //@"nameChangedTime" : @"name.info[1].nameChangedTime",
    [PerformanceModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 @"desc" : @"desciption",
                 @"oldName" : @"name.oldName",
                 @"nowName" : @"name.newName",
                 @"nameChangedTime" : @"name.info[1].nameChangedTime",
                 @"bag" : @"other.bag"
                 };
    }];
    
    /*
     结论:YYModel的效率高一些,json内的数组数据yy不能直接取某个元素,mj可以做到。
     */
    
    PerformanceModel *per = [PerformanceModel mj_objectWithKeyValues:dict];
    PerformanceModel1 *per1 = [PerformanceModel1 yy_modelWithJSON:dict];

    NSLog(@"%f",CACurrentMediaTime());

    for (int i=0; i<10000; i++) {
//        NSDictionary *dict = [per yy_modelToJSONObject];
        NSDictionary *dict1 = [per1 mj_JSONObject];
    }
    
    NSLog(@"%f",CACurrentMediaTime());
    
    
    [TestItem mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"statuses" : @"Status",
                 // @"statuses" : [Status class],
                 @"ads" : @"Ad"
                 // @"ads" : [Ad class]
                 };
    }];
    
    dict = @{
             @"statuses" : @[
                     @{
                         @"text" : @"Nice weather!",
                         @"user" : @{
                                 @"name" : @"Rose",
                                 @"icon" : @"nami.png"
                                 }
                         },
                     @{
                         @"text" : @"Go camping tomorrow!",
                         @"user" : @{
                                 @"name" : @"Jack",
                                 @"icon" : @"lufy.png"
                                 }
                         }
                     ],
             @"ads" : @[
                     @{
                         @"image" : @"1.jpg",
                         @"url" : @"http://www.ad01.com"
                         },
                     @{
                         @"image" : @"11.jpg",
                         @"url" : @"http://www.ad02.com"
                         }
                     ],
             @"totalNumber" : @"2014"
             };
    
    TestItem *result = [TestItem mj_objectWithKeyValues:dict];
    for (Status *status in result.statuses) {
        NSString *text = status.text;
        NSString *name = status.user.name;
        NSString *icon = status.user.icon;
        NSLog(@"text=%@, name=%@, icon=%@", text, name, icon);
    }
}

@end
