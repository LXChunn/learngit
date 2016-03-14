//
//  XPVoteContentCell.m
//  XPApp
//
//  Created by jy on 16/1/6.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "UIView+HESizeHeight.h"
#import "XPVoteContentCell.h"
#define BoundsWidth [UIScreen mainScreen].bounds.size.width

@interface XPVoteContentCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) XPDetailModel *model;

@end

@implementation XPVoteContentCell

+ (CGFloat)cellHeightWithModel:(XPDetailModel *)model
{
    float titleHeight = [UIView getTextSizeHeight:model.title font:14 withSize:CGSizeMake(BoundsWidth - 32, MAXFLOAT)];
    float contentHeight = [UIView getTextSizeHeight:model.content font:14 withSize:CGSizeMake(BoundsWidth - 32, MAXFLOAT)];
    return titleHeight + contentHeight + 39;
}

- (void)awakeFromNib
{
    RAC(self.titleLabel, text) = [RACObserve(self, model.title) ignore:nil];
    RAC(self.contentLabel, text) = [RACObserve(self, model.content) ignore:nil];
}

- (void)bindModel:(XPBaseModel *)model
{
    if(!model) {
        return;
    }
    
    self.model = (XPDetailModel *)model;
}

@end
