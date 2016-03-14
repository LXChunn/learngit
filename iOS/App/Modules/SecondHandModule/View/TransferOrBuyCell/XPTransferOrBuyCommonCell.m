//
//  XPTransferOrBuyCommonCell.m
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPTransferOrBuyCommonCell.h"
#import "UITextField+XPLimitLength.h"

#define kMaxLength 20

@interface XPTransferOrBuyCommonCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) TextFieldCommonInputBlock textFieldInputBlock;
@end

@implementation XPTransferOrBuyCommonCell

- (void)configureUIWithModel:(XPTransferOrBuyModel *)model
                        type:(TransferOrBuyCommonType)type
                       block:(TextFieldCommonInputBlock)block
{
    _textField.delegate = self;
    if(type == TransferOrBuyCommonTypeOfTitle) {
        _textFieldInputBlock = block;
        _textField.placeholder = @"请输入宝贝标题（1-20个字）";
        [_textField rac_textSignalWithLimitLength:20];
        _textField.text = model.goodsTitle;
    } else {
        _textFieldInputBlock = block;
        _textField.placeholder = @"请输入联系电话(选填项)";
        _textField.text = model.mobile;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(_textFieldInputBlock) {
        _textFieldInputBlock(_textField.text);
    }
}

@end
