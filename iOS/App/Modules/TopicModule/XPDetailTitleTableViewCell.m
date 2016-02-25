//
//  XPDetailTitleTableViewCell.m
//  XPApp
//
//  Created by iiseeuu on 15/12/31.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPDetailTitleTableViewCell.h"
#import "XPDetailPostModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>
#import <DateTools/DateTools.h>
#import <UIImageView+AFNetworking.h>


@interface XPDetailTitleTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *createTime;

@property (nonatomic, strong)XPDetailPostModel *model;


@end




@implementation XPDetailTitleTableViewCell


- (void)awakeFromNib
{
    RAC(self.nickname,text) = [RACObserve(self, model.author.nickname) ignore:nil];
    RAC(self.createTime,text) = [[RACObserve(self, model.createdAt) ignore:nil] map:^id(id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        return [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    }];

    [[RACObserve(self, model.author.avatarUrl) ignore:nil] subscribeNext:^(id x) {
        [self.iconImage setImageWithURL:[NSURL URLWithString:self.model.author.avatarUrl]];
    }];
    
    
}

- (void)bindModel:(id)model
{
    if (model == nil)
    {
        return ;
    }
    NSParameterAssert([model isKindOfClass:[XPDetailPostModel class]]);
    self.model = model;
}
@end
