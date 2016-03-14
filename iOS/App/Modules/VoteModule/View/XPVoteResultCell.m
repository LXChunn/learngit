//
//  XPVoteResultCell.m
//  XPApp
//
//  Created by jy on 16/1/6.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "UIView+HESizeHeight.h"
#import "XPVoteResultCell.h"
#define BoundsWidth [UIScreen mainScreen].bounds.size.width

@interface XPVoteResultCell ()
@property (weak, nonatomic) IBOutlet UILabel *resultOptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressWidthLayoutConstraint;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (nonatomic, strong) XPOptionModel *model;

@end

@implementation XPVoteResultCell

+ (CGFloat)cellHeightWithModel:(XPOptionModel *)model
{
    float optionHeight = [UIView getTextSizeHeight:model.descriptionField font:14 withSize:CGSizeMake(BoundsWidth - 58, MAXFLOAT)];
    return optionHeight + 48;
}

- (void)awakeFromNib
{
    RAC(self, resultOptionLabel.text) = [RACObserve(self, model.descriptionField) ignore:nil];
    [[RACObserve(self, model.votesCount) ignore:nil] subscribeNext:^(id x) {
        NSInteger progress = ((float)self.model.votesCount * 1.0f)/((float)self.model.totalVoteCount * 1.0f)*100;
        NSString *tip = @"%";
        _progressLabel.text = [NSString stringWithFormat:@"%ld%@", progress, tip];
        self.progressWidthLayoutConstraint.constant = 2 * progress;
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
