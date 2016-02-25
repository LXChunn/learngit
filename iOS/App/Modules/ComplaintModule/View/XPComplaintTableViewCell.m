//
//  XPComplaintViewCell.m
//  XPApp
//
//  Created by Mac OS on 15/12/28.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPComplaintModel.h"
#import "XPComplaintTableViewCell.h"
#import <DateTools/DateTools.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>

@interface XPComplaintTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (nonatomic,strong)XPComplaintModel *model;

@end

@implementation XPComplaintTableViewCell

- (void)awakeFromNib
{
    RAC(self.contentLable, text) = [RACObserve(self, model.content) ignore:nil];
    RAC(self.timeLable,text) = [[RACObserve(self, model.createdAt) ignore:nil] map:^id(id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.createdAt.doubleValue];
        return [date formattedDateWithFormat:@"YYYY-MM-dd  hh:mm"];
    }];
    [[RACObserve(self, model.status) ignore:nil] subscribeNext:^(id x) {
        switch ([x intValue]){
            case 1:
                self.iconImageView.image = [UIImage imageNamed:@"common_circle_processed"];
                break;
            case 2:
                self.iconImageView.image = [UIImage imageNamed:@"common_circle_processing"];
                break;
            case 3:
                self.iconImageView.image = [UIImage imageNamed:@"common_circle_completed"];
                break;
            case 4:
                self.iconImageView.image = [UIImage imageNamed:@"common_circle_pending"];
                break;
            default:
            break;}
    }];
}

- (void)bindModel:(XPComplaintModel*)model
{
    NSParameterAssert([model isKindOfClass:[XPComplaintModel class]]);
    self.model = model;
}

@end