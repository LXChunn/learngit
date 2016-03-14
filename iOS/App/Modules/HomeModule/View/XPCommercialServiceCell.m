//
//  XPCommercialServiceCell.m
//  XPApp
//
//  Created by jy on 16/1/14.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPCommercialServiceCell.h"
#import "UIView+block.h"

#define BoundWidth [UIScreen mainScreen].bounds.size.width

@interface XPCommercialServiceCell ()
@property (weak, nonatomic) IBOutlet UIImageView *communityBulletinImageView;
@property (weak, nonatomic) IBOutlet UIImageView *
propertyWarrantyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *
propertyPaymentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *communityForumsImageView;
@property (nonatomic,strong) ClickCommercialServiceBlock block;
@end

@implementation XPCommercialServiceCell

- (void)awakeFromNib {
    __weak typeof(self) weakSelf = self;
    [_communityBulletinImageView whenTapped:^{
        [weakSelf communityBulletinAction];
    }];
    [_propertyPaymentImageView whenTapped:^{
        [weakSelf propertyPaymentAction];
    }];
    [_propertyWarrantyImageView whenTapped:^{
        [weakSelf propertyWarrantyAction];
    }];
    [_communityForumsImageView whenTapped:^{
        [weakSelf communityForumsAction];
    }];
}

+ (float)cellHeight{
    float height = (BoundWidth - 14)/2.0 * 54/91.0 * 2.0;
    return 39 + 5 + 12 + height;
}

- (void)whenClickCommercialService:(ClickCommercialServiceBlock)block{
    _block = block;
}

- (void)communityBulletinAction{
    if (_block) {
        _block(CommercialServiceTypeOfCommunityBulletin);
    }
}

- (void)propertyWarrantyAction{
    if (_block) {
        _block(CommercialServiceTypeOfPropertyWarranty);
    }
}

- (void)propertyPaymentAction{
    if (_block) {
        _block(CommercialServiceTypeOfPropertyPayment);
    }
}

- (void)communityForumsAction{
    if (_block) {
        _block(CommercialServiceTypeOfCommunityForums);
    }
}


@end
