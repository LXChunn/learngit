//
//  XPHousekeepingNewsListCell.h
//  XPApp
//
//  Created by jy on 16/2/22.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPBaseTableViewCell.h"
#import "XPHousekeepingListModel.h"

@interface XPHousekeepingNewsListCell : XPBaseTableViewCell

+ (float)cellHeight:(XPHousekeepingListModel *)model;

- (void)bindModel:(XPHousekeepingListModel *)model;

@end
