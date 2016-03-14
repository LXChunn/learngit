//
//  XPSecondHandDetailOfDescribtionCell.m
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "XPDetailImageShowView.h"
#import "XPSecondHandDetailModel.h"
#import "XPSecondHandDetailOfDescriptionCell.h"
#import <DateTools/DateTools.h>
#import <ReactiveCocoa.h>
#import <XPKit/XPKit.h>

@interface XPSecondHandDetailOfDescriptionCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet XPDetailImageShowView *showImageDetailView;
@property (nonatomic, strong) XPSecondHandDetailModel *model;

@end

@implementation XPSecondHandDetailOfDescriptionCell

- (void)awakeFromNib
{
    @weakify(self);
    RAC(self.titleLabel, text) = [RACObserve(self, model.title) ignore:nil];
    [[RACObserve(self, model.price) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        if([x isEqualToString:@"-1"]) {
            self.priceLabel.text = @"￥面议";
        } else {
            self.priceLabel.text = [NSString stringWithFormat:@"￥%.02f", [x floatValue]];
        }
    }];
    [[RACObserve(self, model.picUrls) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.showImageDetailView loadUIWithImagesArray:x];
    }];
}

- (void)bindModel:(XPBaseModel *)model
{
    if(!model) {
        return;
    }
    NSParameterAssert([model isKindOfClass:[XPSecondHandDetailModel class]]);
    self.model = (XPSecondHandDetailModel *)model;
}

@end
