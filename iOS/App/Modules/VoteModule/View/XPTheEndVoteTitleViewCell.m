//
//  XPTheEndVoteTitleViewCell.m
//  XPApp
//
//  Created by Mac OS on 16/1/4.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPTheEndVoteTitleViewCell.h"
#import "XPDetailModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>
#import <DateTools/DateTools.h>
#import <UIImageView+AFNetworking.h>

@interface XPTheEndVoteTitleViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong)XPDetailModel *model;

@end

@implementation XPTheEndVoteTitleViewCell

- (void)awakeFromNib
{
    RAC(self.nickNameLabel,text) = [RACObserve(self, model.author.nickname) ignore:nil];
    RAC(self.timeLabel,text) = [[RACObserve(self, model.createdAt) ignore:nil] map:^id(id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        return [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    }];
    [[RACObserve(self, model.author.avatarUrl) ignore:nil] subscribeNext:^(id x) {
        [self.titleImageView setImageWithURL:[NSURL URLWithString:self.model.author.avatarUrl]];
    }];
    
}

- (void)bindModel:(id)model
{
    if (model == nil)
    {
        return ;
    }
    NSParameterAssert([model isKindOfClass:[XPDetailModel class]]);
    self.model = model;
}


@end
