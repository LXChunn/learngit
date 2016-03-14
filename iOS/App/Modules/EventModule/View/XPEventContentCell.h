//
//  XPEventContentCell.h
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"
#import "XPBaseTableViewCell.h"
#import "XPDetailModel.h"

@interface XPEventContentCell : XPBaseTableViewCell

+ (float)cellHeightWithModel:(XPDetailModel *)model;

- (void)bindModel:(XPBaseModel *)model;

@end
