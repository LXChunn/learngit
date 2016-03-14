//
//  XPCommonTableViewCell.h
//  XPApp
//
//  Created by iiseeuu on 15/12/29.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"
#import "XPBaseTableViewCell.h"

@interface XPCommonTableViewCell : XPBaseTableViewCell

- (void)bindModel:(XPBaseModel *)model;

+ (NSInteger)cellHeightWithArray:(NSArray *)images;

- (void)hidden;
@end
