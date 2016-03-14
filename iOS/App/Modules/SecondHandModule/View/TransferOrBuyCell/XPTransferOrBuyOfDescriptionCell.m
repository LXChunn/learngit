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
@property (nonatomic, strong) TextViewInputBlock textViewBlock;

@end

@implementation XPTransferOrBuyOfDescriptionCell

- (void)awakeFromNib
{
    _descriptionTextView.delegate = self;
    [[[_descriptionTextView rac_textSignal] ignore:nil] subscribeNext:^(id x) {
        if(_textViewBlock) {
            _textViewBlock(_descriptionTextView.text);
        }
    }];
}

- (void)configureUIWithModel:(XPTransferOrBuyModel *)model block:(TextViewInputBlock)block
{
    _descriptionTextView.text = model.goodsDescriptions;
    _descriptionTextView.font = [UIFont systemFontOfSize:16];
    _textViewBlock = block;
}

@end
