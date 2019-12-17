//
//  CacheCell2.m
//  QMUIKit_Study
//
//  Created by zidonj on 2019/12/16.
//  Copyright © 2019 zidonj. All rights reserved.
//

#import "CacheCell2.h"
#import <SDWebImage/SDWebImage.h>
#import "CacheItem.h"
#import <QMUIKit/QMUIKit.h>

@interface CacheCell2 ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation CacheCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize resultSize = CGSizeMake(size.width, 0);
    
    CGFloat titleLabelWidth = size.width - 15 - 15;
    
    CGFloat resultHeight = 100 + 15;
    
    if (self.descLabel.text.length > 0) {
        CGSize contentSize = [self.descLabel sizeThatFits:CGSizeMake(titleLabelWidth, CGFLOAT_MAX)];
        resultHeight += contentSize.height + 15;
    }
    resultSize.height = resultHeight + 15;
    return resultSize;
}

- (void)setContent:(id)model {
    
    CacheItem *item = (CacheItem *)model;
    [self.imgView1 sd_setImageWithURL:[NSURL URLWithString:item.imgUrl1]];
    [self.imgView2 sd_setImageWithURL:[NSURL URLWithString:item.imgUrl2]];
    self.descLabel.text = item.text;
}


@end
