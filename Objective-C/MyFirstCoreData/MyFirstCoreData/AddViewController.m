//
//  AddViewController.m
//  MyFirstCoreData
//
//  Created by zidon on 15/5/11.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import "AddViewController.h"
#import <CoreData/CoreData.h>
#import "Entity.h"
#import "pinyin.h"
#import "Person.h"


@interface AddViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

//声明ImagePicker
@property (strong, nonatomic) UIImagePickerController *picker;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //通过application对象的代理对象获取上下文
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    self.managedObjectContext = [delegate managedObjectContext];
    
    
    //初始化并配置ImagePicker 相册
    self.picker = [[UIImagePickerController alloc] init];
    //picker是否可以编辑
    self.picker.allowsEditing = YES;
    //注册回调
    self.picker.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jojo)];
    [self.headImage addGestureRecognizer:tap];
}

-(void)jojo
{
    //跳转到ImagePickerView来获取按钮
    [self presentViewController:self.picker animated:YES completion:^{}];
}

//回调图片选择取消
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //在ImagePickerView中点击取消时回到原来的界面
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//实现图片回调方法，从相册获取图片
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //获取到编辑好的图片
    UIImage * image = info[UIImagePickerControllerEditedImage];
    
    //把获取的图片设置成用户的头像
    self.headImage.image=image;
    //返回到原来View
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

- (IBAction)save:(id)sender {
//    //获取Person的实体对象
//    Entity *person = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Entity class]) inManagedObjectContext:self.managedObjectContext];
//    
//    //给person赋值
//    person.name = self.name.text;
//    person.number = self.phone.text;
//    person.firstN = [NSString stringWithFormat:@"%c", pinyinFirstLetter([person.name characterAtIndex:0])-32];
//    
//    //通过上下文存储实体对象
////    NSError *error;
////    if (![self.managedObjectContext save:&error]) {
////        //NSLog(@"%@", [error localizedDescription]);
////    }
//    //返回上一层的view
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    Person *person = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Person class]) inManagedObjectContext:self.managedObjectContext];
    //如果person为空则新建，如果已经存在则更新
    if (self.person == nil)
    {
        self.person = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Person class]) inManagedObjectContext:self.managedObjectContext];
    }
    //赋值
    self.person.name = self.name.text;
    self.person.tel = self.phone.text;
    self.person.firstN = [NSString stringWithFormat:@"%c", pinyinFirstLetter([self.person.name characterAtIndex:0])-32];
    
    //把button上的图片存入对象
    UIImage *buttonImage = self.headImage.image;
    self.person.imageData = UIImagePNGRepresentation(buttonImage);
    
    //保存
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    //保存成功后POP到表视图
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
