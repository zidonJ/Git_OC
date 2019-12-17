//
//  CacheCell1.m
//  QMUIKit_Study
//
//  Created by zidonj on 2019/12/16.
//  Copyright © 2019 zidonj. All rights reserved.
//

#import "CacheCell1.h"
#import <SDWebImage/SDWebImage.h>
#import "CacheItem.h"
#import <QMUIKit/QMUIKit.h>

@interface CacheCell1 ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *aButton;

@end

@implementation CacheCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize resultSize = CGSizeMake(size.width, 0);
    
    CGFloat titleLabelWidth = size.width - 15 - 100 - 15;
    
    CGFloat resultHeight = 100 + 15;
    
    if (self.titleLabel.text.length > 0) {
        CGSize contentSize = [self.titleLabel sizeThatFits:CGSizeMake(titleLabelWidth, CGFLOAT_MAX)];
        if (contentSize.height > 100) {
            resultHeight = contentSize.height + 15;
        }
    }
    resultSize.height = resultHeight + 30 + 18;
    return resultSize;
}

- (void)setContent:(id)model {
    CacheItem *item = (CacheItem *)model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.imgUrl1]];
    self.titleLabel.text = item.text;
}

@end
