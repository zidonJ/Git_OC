//
//  RightTableViewCell.m
//  MyXmpp
//
//  Created by zidon on 15/5/11.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import "RightTableViewCell.h"

@implementation RightTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _sendMessage=[[UILabel alloc] initWithFrame:CGRectMake(Screen_Width-5, 2, 0, 40)];
        _sendMessage.lineBreakMode=NSLineBreakByCharWrapping;
        _sendMessage.numberOfLines=0;
        _sendMessage.backgroundColor=[UIColor lightGrayColor];
        
        _sendMessage.layer.borderWidth=1;
        _sendMessage.layer.borderColor=[UIColor redColor].CGColor;
        
        [self.contentView addSubview:_sendMessage];
    }
    return self;
}

-(void)setContent:(NSString *)content
{
    _content=content;
    _sendMessage.text=content;
    CGSize size=[_content boundingRectWithSize:CGSizeMake(Screen_Width-100, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    float height=(size.height>=40)?size.height:40;
    _sendMessage.frame=CGRectMake(Screen_Width-size.width-5, 2, size.width, height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
