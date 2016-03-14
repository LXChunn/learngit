//
//  XPFinancialServicesCell.m
//  XPApp
//
//  Created by jy on 16/1/14.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPFinancialServicesCell.h"

@interface XPFinancialServicesCell ()
@property (nonatomic,strong) ClickFinancialServicesBlock block;

@end

@implementation XPFinancialServicesCell

- (void)awakeFromNib {
    // Initialization code
}

+ (float)cellHeight{
    return 145;
}

- (void)whenClickFinaccialService:(ClickFinancialServicesBlock)block{
    _block = block;
}

- (IBAction)creditCardAction:(id)sender {
    if (_block) {
        _block(FinancialServicesTypeOfcreditCard);
    }
}

- (IBAction)loanAction:(id)sender {
    if (_block) {
        _block(FinancialServicesTypeOfloan);
    }
}

- (IBAction)CCBBuyAction:(id)sender {
    if (_block) {
        _block(FinancialServicesTypeOfCCBBuy);
    }
}


@end
