//
//  XPMaintenanceTableViewCell.m
//  XPApp
//
//  Created by iiseeuu on 15/12/24.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPMyMaintenanceTableViewCell.h"
#import "XPMyMaintenanceModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>
#import <DateTools/DateTools.h>
#import <MJRefresh/MJRefresh.h>

@interface XPMyMaintenanceTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(nonatomic,strong)XPMyMaintenanceModel*model;

@end

@implementation XPMyMaintenanceTableViewCell

-(void)awakeFromNib
{
    RAC(self.contentLabel,text) = [RACObserve(self, model.content) ignore:nil];
    RAC(self.timeLabel,text) = [[RACObserve(self, model.createdAt) ignore:nil] map:^id(id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.createdAt.doubleValue];
        return[date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    }];
    self.typeLabel.layer.cornerRadius = 2;
    self.typeLabel.clipsToBounds = YES;
   [[RACObserve(self, model.type) ignore:nil] subscribeNext:^(id x) {
       switch ([x intValue]){
           case 1:
               self.typeLabel.text = @"供水报修";
               self.typeLabel.backgroundColor = [UIColor colorWithHexString:@"#67c681"];
               break;
           case 2:
                self.typeLabel.text = @"供电报修";
               self.typeLabel.backgroundColor = [UIColor colorWithHexString:@"#4BA9E9"];
               break;
           case 3:
                self.typeLabel.text = @"燃气报修";
               self.typeLabel.backgroundColor = [UIColor colorWithHexString:@"#E59A73"];
               break;
           case 100:
               self.typeLabel.text = @"其他报修";
               self.typeLabel.backgroundColor = [UIColor colorWithHexString:@"#FC6472"];
               break;
           default:
           break;}
   }];
    
   [[RACObserve(self, model.status) ignore:nil] subscribeNext:^(id x) {
       switch ([x intValue]){
           case 1:
               self.iconImage.image = [UIImage imageNamed:@"common_circle_processed"];
               break;
           case 2:
               self.iconImage.image = [UIImage imageNamed:@"common_circle_processing"];
               break;
           case 3:
               self.iconImage.image = [UIImage imageNamed:@"common_circle_completed"];
               break;
           case 100:
               self.iconImage.image = [UIImage imageNamed:@"common_circle_pending"];
               break;
           default:
           break;}
   }];
}


-(void)bindModel:(id )model
{
    NSParameterAssert([model isKindOfClass:[XPMyMaintenanceModel class]]);
    self.model = model;
}



@end
