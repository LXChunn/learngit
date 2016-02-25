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
@property (weak, nonatomic) IBOutlet UIButton *payCostButton;

@end

@implementation XPPropertyBillTableViewCell

- (void)awakeFromNib
{
    RAC(self.titleLabel, text) = [RACObserve(self, model.title) ignore:nil];
}

- (void)bindModel:(id)model
{
    NSParameterAssert([model isKindOfClass:[XPPropertyBillModel class]]);
    self.model = model;
}

@end

