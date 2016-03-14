//
//  XPDetailConvenienctStoreTableViewCell.m
//  XPApp
//
//  Created by iiseeuu on 16/1/18.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPDetailConvenienctStoreTableViewCell.h"
#import <XPAdPageView/XPADView.h>
#import <Masonry/Masonry.h>
#import <SDWebImage-ProgressView/UIImageView+ProgressView.h>
#import <XPKit/XPKit.h>
#import <UIImageView+WebCache.h>

@interface XPDetailConvenienctStoreTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end


@implementation XPDetailConvenienctStoreTableViewCell


-(void)awakeFromNib
{
    RAC(self.titleLabel,text) = [RACObserve(self, detailModel.title) ignore:nil];
    RAC(self.contentLabel,text) = [RACObserve(self, detailModel.content) ignore:nil];
    RAC(self.priceLabel,text) = [RACObserve(self, detailModel.priceStr) ignore:nil];
    
}


@end
