//
//  XPMyCommentCell.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/25.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPMyCommentCell.h"

@implementation XPMyCommentCell

- (void)awakeFromNib
{
    self.nickNameWidthLayout.constant = [UIScreen mainScreen].bounds.size.width/2-30;
}

@end
