//
//  XPJFZDTableViewCell.m
//  XPApp
//
//  Created by Mac OS on 15/12/19.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPPropertyBillModel.h"
#import "XPPropertyBillTableViewCell.h"
#import <DateTools/DateTools.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>

@interface XPPropertyBillTableViewCell ()
@property (nonatomic, strong) XPPropertyBillModel *model;
@property (weak, nonatomic) IBOutlet UILabel *paycostLabel;

@end

@implementation XPPropertyBillTableViewCell

- (void)awakeFromNib
{
    RAC(self.titleLabel, text) = [RACObserve(self, model.title) ignore:nil];
    RAC(self.amountLabel, text) = [RACObserve(self, model.dollarAmount) ignore:nil];
    
    [[RACObserve(self, model.type) ignore:nil] subscribeNext:^(id x) {
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        switch([x intValue]) {
            case 1: {
                self.iconImageView.image = [UIImage imageNamed:@"propertyill_global_type"];
            }
                break;
                
            case 2: {
                self.iconImageView.image = [UIImage imageNamed:@"propertyill_park_type"];
            }
                break;
                
            case 3: {
                self.iconImageView.image = [UIImage imageNamed:@"propertyill_water_type"];
            }
                break;
                
            case 4: {
                self.iconImageView.image = [UIImage imageNamed:@"propertyill_health_type"];
            }
                break;
                
            case 100: {
                self.iconImageView.image = [UIImage imageNamed:@"propertyill_other_type"];
            }
                break;
                
            default: {
            }
                break;
        }
    }];
    
    [[RACObserve(self, model.status) ignore:nil] subscribeNext:^(id x) {
        switch([x intValue]) {
            case 1: {
                [self.paycostLabel setHidden:NO];
            }
                break;
                
            case 2: {
                [self.paycostLabel setHidden:YES];
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
    NSParameterAssert([model isKindOfClass:[XPPropertyBillModel class]]);
    self.model = model;
    float amount = [self.model.amount floatValue];
    self.model.dollarAmount = [NSString stringWithFormat:@"￥%.2f", amount];
}

@end

