//
//  ViewController.m
//  TestKVC
//
//  Created by Zidon on 15/1/27.
//  Copyright (c) 2015年 姜泽东. All rights reserved.
//

#import "ViewController.h"
#import "Book.h"
#import "Author.h"
#import "TestArrayKVO.h"

#ifdef DEBUG
# define YYLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define YYLog(...)
#endif

@interface ViewController ()


@property (nonatomic,strong) NSMutableArray *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TestArrayKVO *t=[[TestArrayKVO alloc] init];
    YYLog(@"kvo获取成员变量：%@",[t valueForKey:@"_title"]);
    
    Book *book=[[Book alloc] init];
    [book setValue:@"《Objective-C入门》" forKey:@"name"];
    [book setValue:@"123" forKey:@"test"];
    NSString *name=[book valueForKey:@"test"];
    YYLog(@"%@",name)
    
    Book *book1=[[Book alloc] init];
    [book1 setValue:@"《Objective-C入门》" forKey:@"name"];
    NSString *name1=[book1 valueForKey:@"name"];
    YYLog(@"%@",name1)
    Author *author=[[Author alloc] init];
    [author setValue:@"Marshal Wu" forKey:@"name"];
    [book1 setValue:author forKey:@"author"];
    NSString *authorName=[book1 valueForKeyPath:@"author.name"];
    YYLog(@"%@",authorName)
    
    Book *book2=[[Book alloc] init];
    Author *author2=[[Author alloc] init];
    [book2 setValue:author2 forKey:@"author"];
    [book2 setValue:@"zhangsan" forKeyPath:@"author.name"];
    [book2 setValue:@"10.4" forKey:@"price"];
    YYLog(@"book price is %@==%@",[book2 valueForKey:@"price"],[book2 valueForKeyPath:@"author.name"])
    
    
    
    Book *book3 =[[Book alloc] init];
    Book *book4=[[Book alloc] init];
    [book4 setValue:@"5.0" forKey:@"price"];
    Book *book5=[[Book alloc] init];
    [book5 setValue:@"4.0" forKey:@"price"];
    NSArray *books=[NSArray arrayWithObjects:book4,book5,nil];
    [book3 setValue:books forKey:@"relativeBooks"];
    
    YYLog(@"relative books price: %@",[book3 valueForKeyPath:@"relativeBooks.price"])
    YYLog(@"relative books count: %@",[book3 valueForKeyPath:@"relativeBooks.@count"])
    YYLog(@"relative books price sum: %@",[book3 valueForKeyPath:@"relativeBooks.@sum.price"])
    YYLog(@"relative books price avg: %@",[book3 valueForKeyPath:@"relativeBooks.@avg.price"])
    YYLog(@"relative books price avg: %@",[book3 valueForKeyPath:@"relativeBooks.@max.price"])
    YYLog(@"relative books price avg: %@",[book3 valueForKeyPath:@"relativeBooks.@min.price"])
    //如果想获得没有重复的价格集合,可以这样:
    YYLog(@"relative books distinct price: %@",[book3 valueForKeyPath:@"relativeBooks.@distinctUnionOfObjects.price"]);
    //在使用@distinctUnionOfObjects后,发现效果是消除重复的价格。
    
    Book *book6=[[Book alloc] init];
    NSArray *bookProperties=[NSArray arrayWithObjects:@"name",@"price",nil];
    
    [book1 mutableArrayValueForKey:@"test"];
        
    NSDictionary *bookPropertiesDictionary=[book6 dictionaryWithValuesForKeys:bookProperties];
    YYLog(@"book values: %@",bookPropertiesDictionary)
    NSDictionary *newBookPropertiesDictionary=[NSDictionary dictionaryWithObjectsAndKeys:@"《Objective C入门》",@"name", @"20.5",@"price",nil];
    [book6 setValuesForKeysWithDictionary:newBookPropertiesDictionary];
    NSLog(@"book with new values: %@",[book4 dictionaryWithValuesForKeys:bookProperties]);
    //另外,还有两个比较高级的内容:nil和覆盖setNilValueForKey方法,覆盖valueForUndefinedKey方法,可自行看reference了解。
    
    
    _data=[NSMutableArray arrayWithArray:bookProperties];
    [self addObserver:self forKeyPath:@"data" options:NSKeyValueObservingOptionNew context:nil];
    [[self mutableArrayValueForKey:@"data"] addObject:@"test"];
}

-(void)insertObject:(id)object inDataAtIndex:(NSUInteger)index{
    [self.data insertObject:object atIndex:index];
}

-(void)removeObjectFromDataAtIndex:(NSUInteger)index
{
    [self.data removeObjectAtIndex:index];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"---:%@",change);
}

@end
