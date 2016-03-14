//
//  XPDetailContentCarpoolTableViewCell.m
//  XPApp
//
//  Created by iiseeuu on 16/2/26.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPDetailContentCarpoolTableViewCell.h"
#import <DateTools/DateTools.h>

@interface XPDetailContentCarpoolTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *startPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *endPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkTitleLabel;

@end


@implementation XPDetailContentCarpoolTableViewCell

-(void)awakeFromNib
{
    RAC(self.startPointLabel,text) = [RACObserve(self, detailModel.startPoint)ignore:nil];
    RAC(self.endPointLabel,text) = [RACObserve(self, detailModel.endPoint)ignore:nil];
    RAC(self.timeLabel,text) = [[RACObserve(self, detailModel.time)ignore:nil] map:^id(id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        return [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    }];
    
    [[RACObserve(self, detailModel.remark)ignore:nil] subscribeNext:^(id x) {
        if ([x length]>1) {
            self.remarkContentLabel.text = x;
        }else{
            self.remarkContentLabel.hidden = YES;
            self.remarkTitleLabel.hidden = YES;
        }
    }];
}

@end
