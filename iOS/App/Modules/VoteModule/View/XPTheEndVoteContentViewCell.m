//
//  XPTheEndVoteContentViewCell.m
//  XPApp
//
//  Created by Mac OS on 16/1/4.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPTheEndVoteContentViewCell.h"
#import "XPDetailModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>
#import <DateTools/DateTools.h>

@interface XPTheEndVoteContentViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong)XPDetailModel *model;

@end

@implementation XPTheEndVoteContentViewCell

- (void)awakeFromNib
{
    RAC(self.titleLabel,text) = [RACObserve(self, model.title) ignore:nil];
    RAC(self.contentLabel,text) = [RACObserve(self, model.content) ignore:nil];
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
