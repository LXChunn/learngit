//
//  XPVoteTableViewCell.h
//  XPApp
//
//  Created by iiseeuu on 15/12/29.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"
#import "XPBaseTableViewCell.h"

@interface XPVoteTableViewCell : XPBaseTableViewCell

- (void)bindModel:(XPBaseModel *)model;

- (void)hidden;

- (void)hiddenForMyPost;//用于我的发布

- (void)hiddenForNeighborhood;//用于我的收藏

@end
