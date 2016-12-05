//
//  CoreDataTableViewCell.h
//  MyFirstCoreData
//
//  Created by zidon on 15/5/11.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoreDataTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@end
