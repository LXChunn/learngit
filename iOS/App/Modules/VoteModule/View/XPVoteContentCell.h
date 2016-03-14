//
//  XPVoteContentCell.h
//  XPApp
//
//  Created by jy on 16/1/6.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"
#import "XPBaseTableViewCell.h"
#import "XPDetailModel.h"
@interface XPVoteContentCell : XPBaseTableViewCell

+ (CGFloat)cellHeightWithModel:(XPDetailModel *)model;

- (void)bindModel:(XPBaseModel *)model;

@end
