//
//  XPEventUserInfoCell.m
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPDetailModel.h"
#import "XPEventUserInfoCell.h"
#import <DateTools/DateTools.h>
#import <XPKit/XPKit.h>
#import <UIImageView+WebCache.h>

@interface XPEventUserInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) ClickAvatorBlock block;
@property (nonatomic, strong) XPDetailModel *model;

@end

@implementation XPEventUserInfoCell

- (void)awakeFromNib
{
    self.avatorImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatorImageView.clipsToBounds = YES;
    [self.avatorImageView whenTapped:^{
        if(_block) {
            _block();
        }
    }];
    RAC(self.nickNameLabel, text) = [RACObserve(self, model.author.nickname) ignore:nil];
    RAC(self.timeLabel, text) = [[RACObserve(self, model.createdAt) ignore:nil] map:^id (id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        return [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    }];
    [[RACObserve(self, model.author.avatarUrl) ignore:nil] subscribeNext:^(id x) {
        [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:self.model.author.avatarUrl] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
    }];
}

- (void)bindModel:(XPBaseModel *)model
{
    if(model == nil) {
        return;
    }
    
    NSParameterAssert([model isKindOfClass:[XPDetailModel class]]);
    self.model = (XPDetailModel *)model;
    [self configureTipUI];
}

- (void)whenClickAvatorWithBlock:(ClickAvatorBlock)block
{
    _block = block;
}

- (void)configureTipUI
{
    NSString *nowTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    if(self.model.extra.endDate.length < 1) {
        if([self.model.extra.startDate integerValue] > [nowTime integerValue]) {
            self.iconImageView.image = [UIImage imageNamed:@"common_todo_label"];
        } else {
            self.iconImageView.image = [UIImage imageNamed:@"common_doing_label"];
        }
    } else {
        if([self.model.extra.endDate integerValue] < [nowTime integerValue]) {
            self.iconImageView.image = [UIImage imageNamed:@"common_done_label"];
        } else {
            if([self.model.extra.startDate integerValue] > [nowTime integerValue]) {
                self.iconImageView.image = [UIImage imageNamed:@"common_todo_label"];
            } else {
                self.iconImageView.image = [UIImage imageNamed:@"common_doing_label"];
            }
        }
    }
}

@end
