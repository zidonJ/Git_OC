//
//  ViewController.h
//  MyFirstCoreData
//
//  Created by zidon on 15/5/11.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestViewController.h"
@interface ViewController : TestViewController

@property (weak, nonatomic) IBOutlet UITableView *coreDataTableView;

- (IBAction)jump:(id)sender;
@end

