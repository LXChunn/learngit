//
//  XPCommnityTableViewCell.m
//  XPApp
//
//  Created by iiseeuu on 15/12/21.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAnnouncementModel.h"
#import "XPCommnityTableViewCell.h"
#import <DateTools/DateTools.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>

@interface XPCommnityTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (nonatomic, strong) XPAnnouncementModel *model;



@end

@implementation XPCommnityTableViewCell

- (void)awakeFromNib
{
    RAC(self.titleLabel, text) = [RACObserve(self, model.title) ignore:nil];
    RAC(self.timeLabel, text) = [[RACObserve(self, model.createdAt) ignore:nil] map:^id (id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        return [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    }];
    [[RACObserve(self, model.type) ignore:nil] subscribeNext:^(id x) {
        NSLog(@"社区公告类型：%d", [self.model.type intValue]);
        self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
        switch([x intValue]) {
            case 1: {
                self.iconImage.image = [UIImage imageNamed:@"communityannouncement _government_type"];
            }
                break;
                
            case 2: {
                self.iconImage.image = [UIImage imageNamed:@"communityannouncement _community_type"];
            }
                break;
                
            case 3: {//资讯公告
                self.iconImage.image = [UIImage imageNamed:@"communityannouncement _information_type"];
            }
                break;
                
            case 100: {
                self.iconImage.image = [UIImage imageNamed:@"communityannouncement _other_type"];
            }
                break;
                
            default: {
            }
                break;
        }
    }];
}

- (void)bindModel:(id)model
{
    NSParameterAssert([model isKindOfClass:[XPAnnouncementModel class]]);
    self.model = model;
}

@end
