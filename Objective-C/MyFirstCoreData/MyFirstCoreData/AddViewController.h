//
//  AddViewController.h
//  MyFirstCoreData
//
//  Created by zidon on 15/5/11.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;

@interface AddViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (nonatomic,strong) Person *person;

//声明CoreData的上下文
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
