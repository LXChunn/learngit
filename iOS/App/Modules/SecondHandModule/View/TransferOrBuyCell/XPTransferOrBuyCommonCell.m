//
//  XPTransferOrBuyCommonCell.m
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPTransferOrBuyCommonCell.h"

@interface XPTransferOrBuyCommonCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,strong) TextFieldCommonInputBlock textFieldInputBlock;
@end

@implementation XPTransferOrBuyCommonCell

- (void)configureUIWithModel:(XPTransferOrBuyModel *)model
                        type:(TransferOrBuyCommonType)type
                       block:(TextFieldCommonInputBlock)block
{
    _textField.delegate = self;
    if (type == TransferOrBuyCommonTypeOfTitle)
    {
        _textFieldInputBlock = block;
        _textField.placeholder = @"输入宝贝标题";
        _textField.text = model.goodsTitle;
    }
    else
    {
        _textFieldInputBlock = block;
        _textField.placeholder = @"联系电话(选填项)";
        _textField.text = model.mobile;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_textFieldInputBlock)
    {
        _textFieldInputBlock(_textField.text);
    }
}


@end
