//
//  XPVoteResultCell.h
//  XPApp
//
//  Created by jy on 16/1/6.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseTableViewCell.h"
#import "XPOptionModel.h"
@interface XPVoteResultCell : XPBaseTableViewCell

+ (CGFloat)cellHeightWithModel:(XPOptionModel *)model;

- (void)bindModel:(XPBaseModel *)model;
@end
