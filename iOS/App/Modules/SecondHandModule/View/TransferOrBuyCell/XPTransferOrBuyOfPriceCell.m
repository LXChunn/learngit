//
//  XPTransferOrBuyOfPriceCell.m
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPTransferOrBuyOfPriceCell.h"

@interface XPTransferOrBuyOfPriceCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (nonatomic, strong) TextFieldPriceInputBlock priceBlock;
@end

@implementation XPTransferOrBuyOfPriceCell

- (void)configureUIWithModel:(XPTransferOrBuyModel *)model block:(TextFieldPriceInputBlock)block
{
    _priceTextField.placeholder = @"面议";
    _priceBlock = block;
    _priceTextField.delegate = self;
    if([model.price integerValue] == -1) {
        _priceTextField.text = @"面议";
    } else {
        _priceTextField.text = model.price;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(_priceBlock) {
        _priceBlock(_priceTextField.text);
    }
}

@end
