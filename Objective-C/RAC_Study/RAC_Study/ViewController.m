//
//  ViewController.m
//  RAC_Study
//
//  Created by zidonj on 2019/11/24.
//  Copyright © 2019 zidonj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, copy) NSString * (^TestBlock) (NSInteger aa);

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 信号的处理流程


    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 200, 100, 60);
    btn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:btn];
    //监听点击事件
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
        CGRect rect = x.frame;
        rect.size = CGSizeMake(100, 100);
        x.frame = rect;
        NSLog(@"%@",x);
    }];

    //KVO监听按钮frame的改变
    [[btn rac_valuesAndChangesForKeyPath:@"frame" options:(NSKeyValueObservingOptionNew) observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        NSLog(@"frame改变了%@",x);
    }];


    UITextField * textF = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 200, 40)];
    textF.placeholder = @"请输入内容";
    textF.textColor = [UIColor blackColor];
    [self.view addSubview:textF];
    //实时监听输入框中文字的变化
    RACSignal *textFSignal = [textF rac_textSignal];
    [textFSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"输入框的内容--%@",x);
    }];


    RACSignal *bindTextFSignal = [textFSignal bind:^RACSignalBindBlock _Nonnull{
        return ^(NSString *value, BOOL *stop) {
            value = [value stringByAppendingString:@":测试绑定原理实现"];
            return [RACSignal return:value];
        };
    }];
    [bindTextFSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"绑定原理实现:%@",x);
    }];

    //UITextField的UIControlEventEditingChanged事件，免去了KVO
    [[textF rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@",x);
    }];
    //添加监听条件
    [[textF.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return [value isEqualToString:@"100"];//此处为判断条件，当输入的字符为100的时候执行下面方法
    }]subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"输入框的内容为%@",x);
    }];

    // 绑定按钮是否可以点击到输入框判定
    RAC(btn, enabled) = [RACSignal combineLatest:@[[textF rac_signalForControlEvents:UIControlEventEditingChanged]] reduce:^id _Nonnull(UITextField *userName){
        return @(userName.text.length > 11);
    }];

}


- (NSString *)test:(NSString * (^) (NSInteger index))block {
    
    return @"234";
}

@end
