//
//  XPTheEndVoteOptionViewCell.m
//  XPApp
//
//  Created by Mac OS on 16/1/4.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPTheEndVoteOptionViewCell.h"
#import "XPDetailModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>
#import <DateTools/DateTools.h>

@interface XPTheEndVoteOptionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *participationLabel;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;
@property (nonatomic, strong)XPDetailModel *model;

@end

@implementation XPTheEndVoteOptionViewCell

- (void)awakeFromNib
{
    RAC(self.optionLabel,text) = [RACObserve(self, model.description) ignore:nil];
    self.participationLabel.text = @"已有%d人参与,投票结果";
    self.percentageLabel.text = @"%%d";
}
- (void)bindModel:(id)model
{
    if (!model)
    {
        return;
    }
    NSParameterAssert([model isKindOfClass:[XPDetailModel class]]);
    self.model = model;
}


@end
