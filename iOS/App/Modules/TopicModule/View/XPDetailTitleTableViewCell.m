//
//  XPDetailTitleTableViewCell.m
//  XPApp
//
//  Created by iiseeuu on 15/12/31.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "UIView+block.h"
#import "XPDetailPostModel.h"
#import "XPDetailTitleTableViewCell.h"
#import <DateTools/DateTools.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>
#import <UIImageView+WebCache.h>

@interface XPDetailTitleTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (nonatomic, strong) ClickAvatorBlock block;
@property (nonatomic, strong) XPDetailPostModel *model;

@end

@implementation XPDetailTitleTableViewCell

- (void)awakeFromNib
{
    self.iconImage.userInteractionEnabled = YES;
    [self.iconImage whenTapped:^{
        if(_block) {
            _block();
        }
    }];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    RAC(self.nickname, text) = [RACObserve(self, model.author.nickname) ignore:nil];
    RAC(self.createTime, text) = [[RACObserve(self, model.createdAt) ignore:nil] map:^id (id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        return [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    }];
    [[RACObserve(self, model.author.avatarUrl) ignore:nil] subscribeNext:^(id x) {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:self.model.author.avatarUrl] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
    }];
}

- (void)bindModel:(id)model
{
    if(model == nil) {
        return;
    }
    
    NSParameterAssert([model isKindOfClass:[XPDetailPostModel class]]);
    self.model = model;
}

- (void)whenClickAvatorWithBlock:(ClickAvatorBlock)block
{
    _block = block;
}

@end
