//
//  TestCollectionViewCell.m
//  tt
//
//  Created by 姜泽东 on 2017/8/31.
//  Copyright © 2017年 姜泽东. All rights reserved.
//

#import "TestCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import <UIImageView+YYWebImage.h>
#import "FlyImage.h"

@interface TestCollectionViewCell ()

@property (nonatomic,strong,readonly) TModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation TestCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setContentWithModel:(TModel *)model
{
    _model = model;
    [_imgView setPlaceHolderImageName:@"default" thumbnailURL:[NSURL URLWithString:model.imageUrl] originalURL:[NSURL URLWithString:model.imageUrl]];
//    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
//    [_imgView yy_setImageWithURL:[NSURL URLWithString:model.imageUrl] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
}

@end
