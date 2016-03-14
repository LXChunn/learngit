//
//  XPMyFavActivityCell.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/18.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPMyFavActivityCell.h"
#import "XPCcbActivitiesModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>

@interface XPMyFavActivityCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelLine;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *detailTimeLabel;
@property (nonatomic, strong)XPCcbActivitiesModel *model;
@end

@implementation XPMyFavActivityCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)bindModel:(id)model
{
    self.model = model;
    self.detailView.hidden = YES;
    self.titleLabel.text = self.model.title;
    self.timeLabel.text = [NSString stringWithFormat:@"%@至%@",[self cutStr:self.model.startDate],[self cutStr:self.model.endDate]];
    self.userLabel.text = self.model.activityTarget;
}

- (void)detailBindModel:(id)model
{
   self.model = model;
   self.labelLine.hidden = YES;
   self.activityTitleLabel.text = @"活动内容:";
   self.activityTimeLabel.text = @"活动对象:";
   self.detailTimeLabel.text = [NSString stringWithFormat:@"%@至%@",[self cutStr:self.model.startDate],[self cutStr:self.model.endDate]];
   self.timeLabel.text = self.model.activityTarget;
   self.userLabel.text = [NSString stringWithFormat:@"%@",self.model.content];
}

- (NSString *)cutStr:(NSString *)str
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:str.doubleValue];
    NSString *datestr = [NSString stringWithFormat:@"%@",date];
    return [datestr substringToIndex:11];
}
@end
