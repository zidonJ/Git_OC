//
//  ViewController.m
//  ZidonRunTime
//
//  Created by Zidon on 15/1/19.
//  Copyright (c) 2015年 姜泽东. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

#define CustomFormat(a,b) [NSString stringWithFormat:a,b]

@interface ViewController ()
{
    
}
@property (nonatomic,strong) id testRuntimeAddClass;

@property (nonatomic,strong) Class testRuntimeClass;

@property (nonatomic,copy) NSString *itest;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _test1=@"1";
    _test2=@"2";
    _test3=[[NSData alloc] init];
    _test4=4;
    _test5=YES;
    NSLog(@"1%s",object_getClassName(_test1));
    NSLog(@"2%@",object_getClass(_test1));
    [self testReplaceMethod];
}

IMP orginIMP;

NSString * MyUppercaseString(id self, SEL _cmd)
{
    NSLog(@"begin uppercaseString");
    NSString *str = orginIMP(self,_cmd);
    NSLog(@"end uppercaseString");
    return str;
}

-(void)testReplaceMethod
{
    Class strcls = [NSString class];
    SEL  oriUppercaseString = @selector(uppercaseString);
    orginIMP = [NSString instanceMethodForSelector:oriUppercaseString];
    class_replaceMethod(strcls,oriUppercaseString,(IMP)MyUppercaseString,NULL);
    NSString *s = @"hello world";
    NSLog(@"%@",[s uppercaseString]);
}

/**
 *  关联的使用
 */
- (IBAction)test1:(id)sender {
    static char overviewKey;
    NSArray *array=[[NSArray alloc] initWithObjects:@"One", @"Two", @"Three", nil];
    NSString * overview = [[NSString alloc] initWithFormat:@"%@",@"First three numbers"];
    objc_setAssociatedObject(array, &overviewKey, overview, OBJC_ASSOCIATION_RETAIN);
    NSString *str = (NSString *)objc_getAssociatedObject(array, &overviewKey);
    NSLog(@"获取关联对象:%@",str);
    NSLog(@"befor:%@",array);
    objc_removeAssociatedObjects(array);
    NSLog(@"after:%@",array);
}
/**
 *  objc_property_t与Ivar遍历属性和成员变量
 */
- (IBAction)test:(id)sender {
    //  取得当前类类型
    Class cls = [self class];
    
    unsigned int ivarsCnt = 0;
    //　获取类成员变量列表，ivarsCnt为类成员数量 class_copyPropertyList:只取属性  class_copyIvarList:取所有
    //    Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);
    objc_property_t *ivars = class_copyPropertyList(cls, &ivarsCnt);//这是一个数组
    //　遍历成员变量列表，其中每个变量都是Ivar类型的结构体
    for (const objc_property_t *p = ivars; p < ivars + ivarsCnt; ++p){
        objc_property_t const ivar = *p;
        //　获取变量名
        //  NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *key = [NSString stringWithUTF8String:property_getName(ivar)];
        NSLog(@"**:%@",key);
        // 若此变量未在类结构体中声明而只声明为Property,则变量名加前缀 '_'下划线
        // 比如 @property(retain) NSString *abc;则 key == _abc;
        //　获取变量值
        id value = [self valueForKey:key];
        //value=@"aa";
        NSLog(@"!!:%@",value);
        //　取得变量类型
        // 通过 type[0]可以判断其具体的内置类型
        //        const char *type = ivar_getTypeEncoding(ivar);
        const char *type = property_getAttributes(ivar);
        NSLog(@"::%s",type);
    }
    free(ivars);
}

- (IBAction)class:(id)sender {
    _testRuntimeClass = objc_getClass("TestObjectName");
    if (!_testRuntimeClass) {
        Class superClass = [NSObject class];
        _testRuntimeClass = objc_allocateClassPair(superClass, "TestObjectName", 0);
        //添加变量要在"objc_allocateClassPair"---"objc_registerClassPair"之间
        BOOL addSuccess=class_addIvar(_testRuntimeClass, "testProperty",  sizeof(NSString *), 0, "@");
        if (addSuccess) {
            NSLog(@"添加变量成功");
        }
        /*
         Class cls-->被添加方法的类
         SEL name-->可以理解为方法名，这个貌似随便起名，比如我们这里叫sayHello2
         IMP imp-->实现这个方法的函数
         const char *types-->一个定义该函数返回值类型和参数类型的字符串
            <--
            i-->返回值类型int,若是v则表示void
         
            @-->参数id(self)
         
            :-->SEL(_cmd)
         
            @-->id(str)
            -->
         */
        BOOL addMethod=class_addMethod(_testRuntimeClass,@selector(testMethod), (IMP)testMethod, "v@:");
        if (addMethod) {
            NSLog(@"添加方法成功");
        }
        // 注册你创建的这个类
        objc_registerClassPair(_testRuntimeClass);
        
        _testRuntimeAddClass = [[_testRuntimeClass alloc] init];
        //调用添加的方法
        [_testRuntimeAddClass testMethod];
        
        
        unsigned int outCount,i;
        // 获取对象里的属性列表
        Ivar * iva = class_copyIvarList([_testRuntimeAddClass class], &outCount);//返回值是数组
        
        for (i = 0; i < outCount; i++) {
            Ivar property =iva[i];
            //  属性名转成字符串
            NSString *propertyName = [[NSString alloc] initWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
            [_testRuntimeAddClass setValue:@"jojo" forKey:propertyName];
            // 判断该属性是否存在
            NSLog(@"%@--%@",propertyName,[_testRuntimeAddClass valueForKey:propertyName]);
        }
        free(iva);
    }
    NSLog(@"_testRuntimeAddClass:%@",[_testRuntimeAddClass valueForKey:@"testProperty"]);
}
//一定要写,方便OC的调用,实际调用下面的C的方法
- (void)testMethod{
}
//实际调用的是这个C方法
static void testMethod(id self, SEL _cmd) //self和_cmd是必须的，在之后可以随意添加其他参数
{
    Ivar v = class_getInstanceVariable([self class], "testProperty");
    //返回名为itest的ivar的变量的值
    NSString *propertyName = [[NSString alloc] initWithCString:ivar_getName(v) encoding:NSUTF8StringEncoding];
    [self setValue:@"andrew" forKey:propertyName];
    //成功打印出结果
    NSLog(@"%@--%@", propertyName,[self valueForKey:@"testProperty"]);
}

@end
