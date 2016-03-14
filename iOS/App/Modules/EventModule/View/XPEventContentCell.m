//
//  XPEventContentCell.m
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "UIView+HESizeHeight.h"
#import "XPDetailImageShowView.h"
#import "XPEventContentCell.h"

#define BoundsWidth [UIScreen mainScreen].bounds.size.width

@interface XPEventContentCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet XPDetailImageShowView *showImageVIew;
@property (nonatomic, strong) XPDetailModel *model;

@end

@implementation XPEventContentCell
+ (float)cellHeightWithModel:(XPDetailModel *)model
{
    float titleHeight = [UIView getTextSizeHeight:model.title font:16 withSize:CGSizeMake(BoundsWidth - 25, MAXFLOAT)];
    float contentHeight = [UIView getTextSizeHeight:model.content font:14 withSize:CGSizeMake(BoundsWidth - 25, MAXFLOAT)];
    if(model.extra.picUrls.count < 1) {
        return 9 + 15 + 16 + titleHeight + contentHeight;
    }
    
    return titleHeight +contentHeight + 9 + 15 + 110 + 16 + 15;
}

- (void)awakeFromNib
{
    RAC(self.titleLabel, text) = [RACObserve(self, model.title) ignore:nil];
    RAC(self.contentLabel, text) = [RACObserve(self, model.content) ignore:nil];
    [RACObserve(self, model.extra.picUrls) subscribeNext:^(id x) {
        [_showImageVIew loadUIWithImagesArray:x];
    }];
}

- (void)bindModel:(XPBaseModel *)model
{
    if(!model) {
        return;
    }
    
    NSParameterAssert([model isKindOfClass:[XPDetailModel class]]);
    self.model = (XPDetailModel *)model;
}

@end
