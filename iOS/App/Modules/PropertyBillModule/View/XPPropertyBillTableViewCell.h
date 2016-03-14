
//
//  XPJFZDTableViewCell.h
//  XPApp
//
//  Created by Mac OS on 15/12/19.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"
#import "XPBaseTableViewCell.h"

@interface XPPropertyBillTableViewCell : XPBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

- (void)bindModel:(XPBaseModel *)model;

@end