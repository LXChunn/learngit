//
//  XPDetailTitleCarpoolTableViewCell.m
//  XPApp
//
//  Created by iiseeuu on 16/2/26.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPDetailTitleCarpoolTableViewCell.h"
#import <UIImageView+WebCache.h>
#import <DateTools/DateTools.h>

@interface XPDetailTitleCarpoolTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (strong,nonatomic)ClickAvatorBlock clickAvatorBlock;

@end
@implementation XPDetailTitleCarpoolTableViewCell

-(void)awakeFromNib
{
     @weakify(self);
    self.iconImageView.userInteractionEnabled = YES;
    [self.iconImageView whenTapped:^{
        if (_clickAvatorBlock) {
            _clickAvatorBlock();
        }
    }];
    [RACObserve(self, detailModel.author.avatarUrl) subscribeNext:^(id x) {
        @strongify(self);
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:x]placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
    }];
    RAC(self.nickNameLabel,text) = [RACObserve(self, detailModel.author.nickname) ignore:nil];
    RAC(self.createTimeLabel,text) = [[RACObserve(self, detailModel.createdAt) ignore:nil]map:^id(id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        return [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    }];
}

- (void)whenClickAvatorWithBlock:(ClickAvatorBlock)block{
    _clickAvatorBlock = block;
}

@end
