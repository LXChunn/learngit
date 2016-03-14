//
//  XPSecondHandDetailOfUserCell.m
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//


#import "UIView+block.h"
#import "XPLoginModel.h"
#import "XPSecondHandDetailModel.h"
#import "XPSecondHandDetailOfUserCell.h"
#import <DateTools/DateTools.h>
#import <ReactiveCocoa.h>
#import <XPKit/XPKit.h>
#import <UIImageView+WebCache.h>

@interface XPSecondHandDetailOfUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (nonatomic, strong) XPSecondHandDetailModel *model;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) ClickAvatorBlock block;

@end

@implementation XPSecondHandDetailOfUserCell

- (void)awakeFromNib
{
    self.avatorImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatorImageView.userInteractionEnabled = YES;
    [self.avatorImageView whenTapped:^{
        if(_block) {
            _block();
        }
    }];
    @weakify(self);
    RAC(self.nickNameLabel, text) = [RACObserve(self, model.author.nickname) ignore:nil];
    RAC(self.timeLabel, text) = [[RACObserve(self, model.createdAt) ignore:nil] map:^id (id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        return [date formattedDateWithFormat:@"YYYY-MM-dd  hh:mm"];
    }];
    [[RACObserve(self, model.author.avatarUrl) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:x] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
    }];
}

- (void)bindModel:(XPBaseModel *)model
{
    if(!model) {
        return;
    }
    NSParameterAssert([model isKindOfClass:[XPSecondHandDetailModel class]]);
    self.model = (XPSecondHandDetailModel *)model;
    [self configurePhoneButton];
}

- (void)configurePhoneButton{
    self.mobile = self.model.mobile;
    if([[XPLoginModel singleton].userId isEqualToString:self.model.author.userId]) {
        self.phoneButton.hidden = YES;
    } else {
        if (self.model.mobile.length < 1) {
            self.phoneButton.hidden = YES;
        }
        else{
            self.phoneButton.hidden = NO;
        }
    }
}

- (void)whenClickAvatorWithBlock:(ClickAvatorBlock)block
{
    _block = block;
}

- (IBAction)callAction:(id)sender
{
    NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", self.mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}

@end
