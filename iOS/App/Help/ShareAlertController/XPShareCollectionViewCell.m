//
//  XPShareCollectionViewCell.m
//  XPApp
//
//  Created by jy on 16/1/12.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPShareCollectionViewCell.h"
#import <UIColor+XPKit.h>

@interface XPShareCollectionViewCell ()

@end

@implementation XPShareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - 29, 0, 58,58)];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 68, self.bounds.size.width, 20)];
        self.titleLabel.textColor = [UIColor colorWithHex:0x474747];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLabel];
        [self addSubview:_iconImageView];
    }
    return self;
}

@end
