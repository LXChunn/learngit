//
//  XPCommonContentCell.m
//  XPApp
//
//  Created by jy on 16/1/4.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPCommonContentCell.h"
#import <XPTextView.h>

@interface XPCommonContentCell ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet XPTextView *textView;
@property (nonatomic, strong) TextViewEndEditingBlock textViewEndEditingBlock;

@end

@implementation XPCommonContentCell

- (void)awakeFromNib
{
    _textView.delegate = self;
    [[[_textView rac_textSignal] ignore:nil] subscribeNext:^(id x) {
        if(_textViewEndEditingBlock) {
            _textViewEndEditingBlock(_textView.text);
        }
    }];
}

- (void)configureUIWithContent:(NSString *)content placeholder:(NSString *)placeholder block:(TextViewEndEditingBlock)block
{
    _textView.placeholder = placeholder;
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.text = content;
    _textViewEndEditingBlock = block;
}

@end
