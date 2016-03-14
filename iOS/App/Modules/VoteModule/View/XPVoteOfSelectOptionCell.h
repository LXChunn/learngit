//
//  XPVoteOfSelectOptionCell.h
//  XPApp
//
//  Created by jy on 16/1/6.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseTableViewCell.h"
#import "XPOptionModel.h"

typedef void (^SelectedOptionBlock)();

@interface XPVoteOfSelectOptionCell : XPBaseTableViewCell
+ (CGFloat)cellHeightWithModel:(XPOptionModel *)model;

- (void)bindModel:(XPBaseModel *)model;

@end
