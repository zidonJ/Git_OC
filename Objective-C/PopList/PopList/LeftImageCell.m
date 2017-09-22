//
//  LeftImageCell.m
//  PopList
//
//  Created by 姜泽东 on 2017/8/31.
//  Copyright © 2017年 MaiTian. All rights reserved.
//

#import "LeftImageCell.h"

@interface LeftImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *text;

@end

@implementation LeftImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setItem:(PopItem *)item
{
    _imgView.image = [UIImage imageNamed:item.image];
    _text.text = item.title;
    _item = item;
}
@end
