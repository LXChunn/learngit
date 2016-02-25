//
//  XPSecondHandDetailOfUserCell.m
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPSecondHandDetailOfUserCell.h"
#import "XPSecondHandDetailModel.h"
#import "XPLoginModel.h"
#import <ReactiveCocoa.h>
#import <XPKit/XPKit.h>
#import <DateTools/DateTools.h>
#import "UIImageView+AFNetworking.h"


@interface XPSecondHandDetailOfUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (nonatomic,strong) XPSecondHandDetailModel *model;

@end

@implementation XPSecondHandDetailOfUserCell

- (void)awakeFromNib
{
    @weakify(self);
    RAC(self.nickNameLabel, text) = [RACObserve(self, model.author.nickname) ignore:nil];
//    RAC(self.timeLabel,text) = [[RACObserve(self, model.createdAt) ignore:nil] map:^id(id value) {
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:value.doubleValue];
//        return [date formattedDateWithFormat:@"YYYY-MM-dd  hh:mm"];
//    }];
    [[RACObserve(self, model.author.avatarUrl) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.avatorImageView setImageWithURL:[NSURL URLWithString:x] placeholderImage:nil];
    }];
    [[RACObserve(self, model.author.userId) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        if ([[XPLoginModel singleton].userId isEqualToString:x])
        {
            self.phoneButton.hidden = YES;
        }
        else
        {
            self.phoneButton.hidden = NO;
        }
    }];
}

- (void)bindModel:(XPBaseModel *)model
{
    if (!model)
    {
        return;
    }
    NSParameterAssert([model isKindOfClass:[XPSecondHandDetailModel class]]);
    self.model = (XPSecondHandDetailModel *)model;
}

- (IBAction)callAction:(id)sender
{
    NSMutableString * phone = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}

@end
