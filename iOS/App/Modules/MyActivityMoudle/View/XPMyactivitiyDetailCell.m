//
//  XPMyactivitiyDetailCell.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/9.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPMyactivitiyDetailCell.h"
#import <UIImageView+AFNetworking.h>

@interface XPMyactivitiyDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UIView *imgeView;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UIButton *partButton;

@end

@implementation XPMyactivitiyDetailCell

- (void)awakeFromNib
{
}

- (void)bindModel:(id)model
{
}

@end
