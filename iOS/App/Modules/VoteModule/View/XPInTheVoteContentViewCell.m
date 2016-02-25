//
//  XPInTheVoteContentViewCell.m
//  XPApp
//
//  Created by Mac OS on 16/1/4.
//  Copyright © 2016年 ShareMerge. All rights reserved.
///Users/mac_os/Desktop/DragonButler副本/Source/iOS/App/Modules/VoteModule/Model/XPDetailModel.m

#import "XPInTheVoteContentViewCell.h"
#import "XPDetailModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>
#import <DateTools/DateTools.h>

@interface XPInTheVoteContentViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@property (nonatomic, strong)XPDetailModel *model;

@end

@implementation XPInTheVoteContentViewCell

- (void)awakeFromNib
{
    RAC(self.titleLable,text) = [RACObserve(self, model.title) ignore:nil];
    RAC(self.contentLable,text) = [RACObserve(self, model.content) ignore:nil];
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
