//
//  XPVoteOfSelectOptionCell.m
//  XPApp
//
//  Created by jy on 16/1/6.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "UIView+HESizeHeight.h"
#import "XPVoteOfSelectOptionCell.h"
#define BoundsWidth [UIScreen mainScreen].bounds.size.width

@interface XPVoteOfSelectOptionCell ()
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (nonatomic, strong) XPOptionModel *model;

@end

@implementation XPVoteOfSelectOptionCell

+ (CGFloat)cellHeightWithModel:(XPOptionModel *)model
{
    float optionHeight = [UIView getTextSizeHeight:model.descriptionField font:14 withSize:CGSizeMake(BoundsWidth - 112, MAXFLOAT)];
    return optionHeight + 26;
}

- (void)awakeFromNib
{
    RAC(self, optionLabel.text) = [RACObserve(self, model.descriptionField) ignore:nil];
    [[RACObserve(self, model.isSelected) ignore:nil] subscribeNext:^(id x) {
        if([x integerValue] == 0) {
            self.selectImageView.image = [UIImage imageNamed:@"common_radio_normal"];
        } else {
            self.selectImageView.image = [UIImage imageNamed:@"common_radio_selected"];
        }
    }];
}

- (void)bindModel:(XPBaseModel *)model
{
    if(!model) {
        return;
    }
    
    NSParameterAssert([model isKindOfClass:[XPOptionModel class]]);
    self.model = (XPOptionModel *)model;
}

@end
