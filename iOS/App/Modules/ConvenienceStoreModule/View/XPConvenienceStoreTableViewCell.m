//
//  XPConvenienceStoreTableViewCell.m
//  XPApp
//
//  Created by iiseeuu on 16/1/15.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPConvenienceStoreTableViewCell.h"
#import "XPConvenienceStoreModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>
#import "UIImageView+WebCache.h"

@interface XPConvenienceStoreTableViewCell()

@property (nonatomic, strong) XPConvenienceStoreModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageHeightLayoutconstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageWidthLayoutconstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceSpace;

@end


@implementation XPConvenienceStoreTableViewCell

-(void)awakeFromNib
{
    RAC(self.titleLabel,text) = [RACObserve(self, model.title) ignore:nil];
    RAC(self.priceLabel,text) = [RACObserve(self, model.priceStr) ignore:nil];
    [[RACObserve(self, model.picUrls) ignore:nil]subscribeNext:^(id x) {
        if (self.model.picUrls.count>0) {
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:self.model.picUrls[0]] placeholderImage:[UIImage imageNamed:@"common_list_default"]];
        }else{
            
            self.iconImageHeightLayoutconstraint.constant = 0;
            self.iconImageWidthLayoutconstraint.constant = 0;
            self.priceSpace.constant = 0;
            self.titleSpace.constant = 0;
        }
    }];
}

- (void)bindModel:(id )model
{
    NSParameterAssert([model isKindOfClass:[XPConvenienceStoreModel class]]);
    self.model = model;
    self.model.priceStr = [NSString stringWithFormat:@"¥%.2f",[self.model.price floatValue]];
}

@end
