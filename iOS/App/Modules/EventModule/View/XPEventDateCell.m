//
//  XPEventDateCell.m
//  XPApp
//
//  Created by jy on 16/1/4.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "UIView+block.h"
#import "XPEventDateCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface XPEventDateCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation XPEventDateCell

- (void)configureUIWithtitle:(NSString *)title date:(NSString *)date
{
    _dateLabel.text = date;
    _titleLabel.text = title;
}

@end
