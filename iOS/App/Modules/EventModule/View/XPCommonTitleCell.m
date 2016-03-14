//
//  XPCommonTitleCell.m
//  XPApp
//
//  Created by jy on 16/1/4.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPCommonTitleCell.h"
#import "UITextField+XPLimitLength.h"
@interface XPCommonTitleCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) TextFieldEndEditingBlock textFieldEndEditingBlock;
@end

@implementation XPCommonTitleCell
- (void)awakeFromNib
{
    _textField.delegate = self;
}

- (void)configureUIWithTitle:(NSString *)title placeholder:(NSString *)placeholder block:(TextFieldEndEditingBlock)block
{
    _textField.placeholder = placeholder;

    _textField.text = title;
    if ([placeholder isEqualToString:@"请选择出发时间"]) {
        _textField.enabled = NO;
    }else if([placeholder isEqualToString:@"请输入手机号（选填）"]||[placeholder isEqualToString:@"请输入联系电话"]) {
        [_textField rac_textSignalWithLimitLength:11];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        _textField.enabled = YES;
        _textField.keyboardType = UIKeyboardTypeDefault;
        [_textField rac_textSignalWithLimitLength:20];
    }
    _textFieldEndEditingBlock = block;
}

- (IBAction)textEndEditingAction:(id)sender
{
    if(_textFieldEndEditingBlock) {
        _textFieldEndEditingBlock(_textField.text);
    }
}

@end
