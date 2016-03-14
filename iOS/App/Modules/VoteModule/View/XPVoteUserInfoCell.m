//
//  XPVoteUserInfoCell.m
//  XPApp
//
//  Created by jy on 16/1/6.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPDetailModel.h"
#import "XPLoginModel.h"
#import "XPVoteUserInfoCell.h"
#import <DateTools/DateTools.h>
#import <ReactiveCocoa.h>
#import <XPKit/XPKit.h>
#import <UIImageView+WebCache.h>

@interface XPVoteUserInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;
@property (nonatomic, strong) XPDetailModel *model;
@property (nonatomic, strong) ClickAvatorBlock block;

@end

@implementation XPVoteUserInfoCell

- (void)awakeFromNib
{
    @weakify(self);
    self.avatorImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatorImageView.userInteractionEnabled = YES;
    [self.avatorImageView whenTapped:^{
        if(_block) {
            _block();
        }
    }];
    RAC(self.nickNameLabel, text) = [RACObserve(self, model.author.nickname) ignore:nil];
    RAC(self.timeLabel, text) = [[RACObserve(self, model.createdAt) ignore:nil] map:^id (id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        return [date formattedDateWithFormat:@"YYYY-MM-dd  hh:mm"];
    }];
    [[RACObserve(self, model.author.avatarUrl) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:x] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
    }];
    [[RACObserve(self, model.extra.open) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        if([x integerValue] == 1) {
            self.tipImageView.image = [UIImage imageNamed:@"common_doing_label"];
        } else {
            self.tipImageView.image = [UIImage imageNamed:@"common_close_label"];
        }
    }];
}

- (void)whenClickAvatorWithBlock:(ClickAvatorBlock)block
{
    _block = block;
}

- (void)bindModel:(XPBaseModel *)model
{
    if(!model) {
        return;
    }
    
    self.model = (XPDetailModel *)model;
}

@end
