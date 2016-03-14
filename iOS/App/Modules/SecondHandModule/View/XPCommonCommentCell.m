//
//  XPCommonCommentCell.m
//  XPApp
//
//  Created by jy on 16/1/5.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "UIColor+XPKit.h"
#import "XPCommonCommentCell.h"

@interface XPCommonCommentCell ()
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end

@implementation XPCommonCommentCell

- (void)configureUIWithName:(NSString *)name content:(NSString *)content
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@", name, content]];
    [str addAttribute:NSForegroundColorAttributeName
                value:[UIColor colorWithHex:0x2667b5]
                range:NSMakeRange(0, name.length + 1)];
    _commentLabel.attributedText = str;
}

@end
