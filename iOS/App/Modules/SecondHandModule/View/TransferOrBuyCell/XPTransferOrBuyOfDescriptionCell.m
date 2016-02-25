//
//  XPTransferOrBuyOfDescriptionCell.m
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPTransferOrBuyOfDescriptionCell.h"
#import <XPTextView.h>

@interface XPTransferOrBuyOfDescriptionCell ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet XPTextView *descriptionTextView;
@property (nonatomic,strong) TextViewInputBlock textViewBlock;

@end

@implementation XPTransferOrBuyOfDescriptionCell

- (void)configureUIWithModel:(XPTransferOrBuyModel *)model block:(TextViewInputBlock)block
{
    _descriptionTextView.font = [UIFont systemFontOfSize:16];
    _descriptionTextView.placeholder = @"输入宝贝描述(选填项)";
    _descriptionTextView.delegate = self;
    _descriptionTextView.text = model.goodsDescriptions;
    _textViewBlock = block;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (_textViewBlock)
    {
        _textViewBlock(textView.text);
    }
}

@end
