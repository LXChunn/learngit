//
//  XPInTheVoteOptionViewCell.m
//  XPApp
//
//  Created by Mac OS on 16/1/4.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPInTheVoteOptionViewCell.h"
#import "XPDetailModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>
#import <DateTools/DateTools.h>

@interface XPInTheVoteOptionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *optionLable;

@property (nonatomic, strong)XPDetailModel *model;

@end

@implementation XPInTheVoteOptionViewCell

- (void)awakeFromNib
{
    RAC(self.optionLable,text) = [RACObserve(self, model.description) ignore:nil];
}
- (IBAction)chooseButton:(UIButton *)sender
{
    
}

- (void)bindModel:(id)model
{
    if (!model)
    {
        return;
    }
    NSParameterAssert([model isKindOfClass:[XPDetailModel class]]);
    self.model = model;
}

@end
