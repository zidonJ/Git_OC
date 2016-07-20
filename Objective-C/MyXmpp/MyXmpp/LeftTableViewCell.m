//
//  LeftTableViewCell.m
//  MyXmpp
//
//  Created by zidon on 15/5/11.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import "LeftTableViewCell.h"

@implementation LeftTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _receivedMessage=[[UILabel alloc] initWithFrame:CGRectMake(5, 2, 0, 40)];
        _receivedMessage.lineBreakMode=NSLineBreakByCharWrapping;
        _receivedMessage.numberOfLines=0;
        _receivedMessage.backgroundColor=[UIColor lightGrayColor];
        [self.contentView addSubview:_receivedMessage];
    }
    return self;
}

-(void)setContent:(NSString *)content
{
    _content=content;
    _receivedMessage.text=content;
    CGSize size=[_content boundingRectWithSize:CGSizeMake(Screen_Width-100, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    float height=(size.height>=40)?size.height:40;
    _receivedMessage.frame=CGRectMake(6, 2, size.width, height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
